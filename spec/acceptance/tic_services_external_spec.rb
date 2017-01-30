require 'spec_helper'

describe 'role::tic_services_external' do
  it_behaves_like 'profile::base'
  it_behaves_like 'role::defined', 'tic_services_external'

	describe package('talend-ipaas-rt-infra') do
    it { should be_installed }
  end

  describe command('/opt/talend/ipaas/rt-infra/bin/shell "wrapper:install --help"') do
    its(:stdout) { should include 'Install the container as a system service in the OS' }
  end

  describe command('/opt/talend/ipaas/rt-infra/bin/client "list"') do
    its(:stdout) { should include 'Data Transfer Service :: Client' }
    its(:stdout) { should include 'Data Transfer Service :: Common' }
    its(:stdout) { should include 'Data Transfer Service :: Core' }
  end

  describe service('rt-infra-service') do
    it { should be_enabled }
    it { should be_running.under('systemd') }
  end

  describe service('nginx') do
    it { should be_enabled }
    it { should be_running.under('systemd') }
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

  describe port(8182) do
    it { should be_listening }
  end

  describe port(8183) do
    it { should be_listening }
  end

  describe port(8184) do
    it { should be_listening }
  end

  describe port(8185) do
    it { should be_listening }
  end

  describe 'Additional Java Packages' do
    subject { package('jre-jce') }
    it { should be_installed }
  end

  describe 'Data Transfer Service configuration' do
    subject { file('/opt/talend/ipaas/rt-infra/etc/org.talend.ipaas.rt.dts.core.cfg').content }
    it { should include 's3.bucket.name.test.data=td-bucket' }
    it { should include 's3.bucket.name.rejected.data=rd-bucket' }
    it { should include 's3.bucket.name.log.data=fl-bucket' }
    it { should include 's3.bucket.name.download=dl-bucket' }
    it { should include 'object.key.prefix=td-prefix' }
  end

  describe 'CMS configuration' do
    subject { file('/opt/talend/ipaas/rt-infra/etc/org.talend.ipaas.rt.cms.config.cfg').content }
    it { should include 'karaf/org.ops4j.pax.url.mvn/org.ops4j.pax.url.mvn.repositories=http://{{username}}:{{password}}@10.0.2.12' }
  end

end
