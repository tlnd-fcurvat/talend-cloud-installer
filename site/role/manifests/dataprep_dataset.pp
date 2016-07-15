# DataPrep dataset
#
class role::dataprep_dataset {

  include ::profile::base
  include ::dataprep_dataset

  role::register_role { 'dataprep_dataset': }

}
