require 'spec_helper'

describe 'tessera' do
  context 'supported operating systems' do
    ['Debian', 'RedHat'].each do |osfamily|
      describe "tessera class without any parameters on #{osfamily}" do
        let(:params) {{ }}
        let(:facts) {{
          :osfamily => osfamily,
        }}

        it { should compile.with_all_deps }

        it { should contain_class('tessera::params') }
        it { should contain_class('tessera::install').that_comes_before('tessera::config') }
        it { should contain_class('tessera::config') }
        it { should contain_class('tessera::service').that_subscribes_to('tessera::config') }

        it { should contain_service('tessera') }
        it { should contain_package('tessera').with_ensure('present') }
      end
    end
  end

  context 'unsupported operating system' do
    describe 'tessera class without any parameters on Solaris/Nexenta' do
      let(:facts) {{
        :osfamily        => 'Solaris',
        :operatingsystem => 'Nexenta',
      }}

      it { expect { should contain_package('tessera') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
