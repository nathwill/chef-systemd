require 'spec_helper'

describe String do
  it 'correctly snake_cases a string' do
    expect('RootDirectoryStartOnly'.underscore).to eq 'root_directory_start_only'
  end

  it 'correctly camelizes a string' do
    expect('root_directory_start_only'.camelize).to eq 'RootDirectoryStartOnly'
  end
end
