require 'spec_helper'

describe 'role::tic_services_internal' do
  it_behaves_like 'profile::base'
  it_behaves_like 'role::defined', 'tic_services_internal'

	describe package('talend-ipaas-rt-infra') do
    it { should be_installed }
  end

  describe command('/opt/talend/ipaas/rt-infra/bin/shell "wrapper:install --help"') do
    its(:stdout) { should include 'Install the container as a system service in the OS' }
  end

  describe service('rt-infra-service') do
    it { should be_enabled }
    it { should be_running.under('systemd') }
  end

  describe port('8180') do
    it { should be_listening }
  end

  describe port('8181') do
    it { should be_listening }
  end

  describe service('nginx') do
    it { should be_enabled }
    it { should be_running.under('systemd') }
  end

  describe command('/usr/bin/curl http://localhost:8181/services') do
    its(:stdout) { should include 'Service list' }
  end

  describe command('/usr/bin/curl http://localhost:8180/services') do
    its(:stdout) { should include 'Service list' }
  end

  describe 'Service configuration' do
    subject { file('/opt/talend/ipaas/rt-infra/etc/rt-infra-service-wrapper.conf').content }
    it { should match /wrapper.jvm_kill.delay\s*=\s*5/ }
    it { should match /wrapper.java.additional.10\s*=\s*-XX:MaxPermSize=256m/ }
    it { should match /wrapper.java.additional.11\s*=\s*-Dcom.sun.management.jmxremote.port=7199/ }
    it { should match /wrapper.java.additional.12\s*=\s*-Dcom.sun.management.jmxremote.authenticate=false/ }
    it { should match /wrapper.java.additional.13\s*=\s*-Dcom.sun.management.jmxremote.ssl=false/ }
    it { should match /wrapper.java.maxmemory\s*=\s*1024/ }
    it { should match /wrapper.disable_restarts\s*=\s*true/ }
  end

  describe 'CMS configuration' do
    subject { file('/opt/talend/ipaas/rt-infra/etc/org.talend.ipaas.rt.cms.config.cfg').content }
    it { should include 'karaf/org.ops4j.pax.url.mvn/org.ops4j.pax.url.mvn.repositories=http://{{username}}:{{password}}@10.0.2.12' }
  end

  describe 'Artifact Manager Service configuration' do
    subject { file('/opt/talend/ipaas/rt-infra/etc/org.talend.ipaas.rt.am.service.cfg').content }
    it { should include 'nexus_urls=http://10.0.2.12:8081/nexus,http://10.0.2.23:8081/nexus' }
  end

  describe 'Custom Resources Service configuration' do
    subject { file('/opt/talend/ipaas/rt-infra/etc/org.talend.ipaas.rt.cr.service.cfg').content }
    it { should include 'bucket.name = mytestbucket' }
    it { should include 'object.key.prefix = mytestprefix' }
  end

  describe 'Trial Registration Service configuration' do
    subject { file('/opt/talend/ipaas/rt-infra/etc/org.talend.ipaas.rt.trial.service.cfg').content }
    it { should include 'confirm.url.template=https://the-frontend.hostname.com/#/signup/login?trialKey=' }
  end

  describe 'Additional Java Packages' do
    subject { package('jre-jce') }
    it { should be_installed }
  end

end
