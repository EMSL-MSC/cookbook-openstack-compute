# encoding: UTF-8

require_relative 'spec_helper'

describe 'openstack-compute::api-metadata' do
  describe 'ubuntu' do
    let(:runner) { ChefSpec::SoloRunner.new(UBUNTU_OPTS) }
    let(:node) { runner.node }
    let(:chef_run) { runner.converge(described_recipe) }

    include_context 'compute_stubs'
    include_examples 'expect_runs_nova_common_recipe'
    include_examples 'expect_creates_nova_state_dir'
    include_examples 'expect_creates_nova_lock_dir'
    include_examples 'expect_upgrades_python_keystoneclient'
    include_examples 'expect_creates_api_paste_template'

    it 'upgrades metadata api packages' do
      expect(chef_run).to upgrade_package 'nova-api-metadata'
    end

    it 'starts metadata api on boot' do
      expect(chef_run).to enable_service 'nova-api-metadata'
    end

    it 'starts metadata api now' do
      expect(chef_run).to start_service 'nova-api-metadata'
    end
    it do
      template = chef_run.template('/etc/nova/api-paste.ini')
      expect(template).to notify('service[nova-api-metadata]').to(:restart)
    end

    # expect_creates_api_paste 'service[nova-api-metadata]'
  end
end
