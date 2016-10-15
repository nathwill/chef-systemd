require 'spec_helper'

describe SystemdCookbook::Mixin::Unit do
  let(:unit_class) do
    Class.new(Chef::Resource) { include SystemdCookbook::Mixin::Unit }
  end

  subject(:unit_obj) { unit_class.new('mock') }

  describe 'sets unit properties' do
    it 'sets triggers_reload' do
      expect(unit_obj.triggers_reload).to eq true
      unit_obj.triggers_reload false
      expect(unit_obj.triggers_reload).to eq false
    end
  end
end

describe SystemdCookbook::Mixin::PropertyHashConversion do
  let(:converting_class) do
    Class.new(Chef::Resource) do
      include SystemdCookbook::Mixin::PropertyHashConversion
      option_properties({
        'Header' => {
          'TestProperty' => { kind_of: String },
          'PurplePeopleEater' => { kind_of: [TrueClass, FalseClass] },
          'Days' => { kind_of: Array },
          'Environment' => { kind_of: Hash }
        }   
      })
    end
  end

  let(:property_hash) do
    {
      'Header' => {
        'PurplePeopleEater' => 'yes',
        'Days' => 'Monday Tuesday',
        'Environment' => 'foo=bar baz=qux'
      }
    }
  end

  subject(:converting_obj) { converting_class.new('mock') }

  it 'sets properties from options hash' do
    expect(subject).to respond_to(:header_test_property)
    expect(subject).to respond_to(:header_purple_people_eater)
  end

  it 'generates hash from properties' do
    subject.header_purple_people_eater true
    subject.header_days %w( Monday Tuesday )
    subject.header_environment({ 'foo' => 'bar', 'baz' => 'qux' })
    expect(
      subject.property_hash({
        'Header' => {
          'TestProperty' => { kind_of: String },
          'PurplePeopleEater' => { kind_of: [TrueClass, FalseClass] },
          'Days' => { kind_of: Array },
          'Environment' => { kind_of: Hash }
        }
      })
    ).to eq property_hash 
  end
end
