require 'spec_helper'
describe 'profile_firewall' do
  context 'on RHEL 6' do
    let(:facts) do {
      :kernel                    => 'Linux',
      :operatingsystem           => 'RedHat',
      :operatingsystemrelease    => '6', 
      :operatingsystemmajrelease => '6', 
    } end
  
    context 'with defaults for all parameters' do
      it { 
        should contain_class('profile_firewall') 
        should contain_firewall('000 accept all icmp').with(
          'proto'  => 'icmp',
          'action' => 'accept')
        should contain_firewall('001 accept all on lo').with(
          'proto'   => 'all',
          'iniface' => 'lo',
          'action'  => 'accept')
        should contain_firewall('002 accept related and established').with(
          'proto'   => 'all',
          'ctstate' => ['RELATED', 'ESTABLISHED'],
          'action'  => 'accept')
        should contain_firewall('050 allow ssh access from anyone').with(
          'proto'   => 'tcp',
          'dport'   => '22',
          'action'  => 'accept')
        should contain_firewall('950 allow zabbix').with(
          'proto'   => 'tcp',
          'dport'   => '10050',
          'action'  => 'accept')
        should contain_firewall('999 deny all').with(
          'proto'   => 'all',
          'action'  => 'reject')
      }
    end
  
    context 'with ssh_src set to 10.0.0.0/8' do
      let(:params) do
      {
        :ssh_src               => '10.0.0.0/8',
        :ssh_src_desc_modifier => 'some place',
      }
      end
      it {
        should contain_class('profile_firewall')
        should contain_firewall('050 allow ssh access from some place').with(
          'proto'  => 'tcp',
          'dport'   => '22',
          'source' => '10.0.0.0/8',
          'action' => 'accept')
      }
    end
  
    context 'with ssh_src_range set to 10.0.0.0-10.0.0.1' do
      let(:params) do
      {
        :ssh_src_range         => '10.0.0.0-10.0.0.1',
        :ssh_src_desc_modifier => 'some place',
      }
      end
      it {
        should contain_class('profile_firewall')
        should contain_firewall('050 allow ssh access from some place').with(
          'proto'     => 'tcp',
          'dport'      => '22',
          'src_range' => '10.0.0.0-10.0.0.1',
          'action'    => 'accept')
      }
    end
  end

  context 'on RHEL 7' do
    let(:facts) do {
      :kernel                    => 'Linux',
      :operatingsystem           => 'RedHat',
      :operatingsystemrelease    => '7', 
      :operatingsystemmajrelease => '7', 
    } end
  
    context 'with defaults for all parameters' do
      it {
        should contain_class('profile_firewall')
        should contain_firewalld_port('allow zabbix').with(
          'ensure'   => 'present',
          'zone'     => 'public',
          'port'     => '10050',
          'protocol' => 'tcp'
        )
        should contain_firewalld_service('Allow access to ssh').with(
          'ensure'  => 'present',
          'zone'    => 'public',
          'service' => 'ssh'
        )
      }
    end

    context 'with ssh_src set to 10.0.0.0' do
      let(:params) do
      {
        :ssh_src => '10.0.0.0',
      }
      end
      it {
        should contain_class('profile_firewall')
        should contain_firewalld_rich_rule('10.0.0.0 access to ssh').with(
          'ensure'  => 'present',
          'zone'    => 'public',
          'source'  => '10.0.0.0/32',
          'service' => 'ssh',
          'action'  => 'accept'
        )
      }
    end
  
    context 'with ssh_src_range set to 10.0.0.0-10.0.0.2' do
      let(:params) do
      {
        :ssh_src_range => '10.0.0.0-10.0.0.2',
      }
      end
      it {
        should contain_class('profile_firewall')
        should contain_firewalld_rich_rule('10.0.0.0 access to ssh').with(
          'ensure'  => 'present',
          'zone'    => 'public',
          'source'  => '10.0.0.0/32',
          'service' => 'ssh',
          'action'  => 'accept'
        )
        should contain_firewalld_rich_rule('10.0.0.1 access to ssh').with(
          'ensure'  => 'present',
          'zone'    => 'public',
          'source'  => '10.0.0.1/32',
          'service' => 'ssh',
          'action'  => 'accept'
        )
        should contain_firewalld_rich_rule('10.0.0.2 access to ssh').with(
          'ensure'  => 'present',
          'zone'    => 'public',
          'source'  => '10.0.0.2/32',
          'service' => 'ssh',
          'action'  => 'accept'
        )
      }
    end
    context 'with ssh_src set to 10.0.0.0/8' do
      let(:params) do
      {
        :ssh_src => '10.0.0.0/8',
      }
      end
      it {
        should contain_class('profile_firewall')
        should contain_firewalld_rich_rule('10.0.0.0/8 access to ssh').with(
          'ensure'  => 'present',
          'zone'    => 'public',
          'source'  => '10.0.0.0/8',
          'service' => 'ssh',
          'action'  => 'accept'
        )
      }
    end
    context 'with ssh_src set to 10.0.0.0-10.0.0.1-10.0.0.2' do
      let(:params) do
      {
        :ssh_src => '10.0.0.0-10.0.0.1-10.0.0.2',
      }
      end
      it {
        should raise_error(Puppet::Error, /Unexpected format for src or src_range/)
      }
    end
  end
end
