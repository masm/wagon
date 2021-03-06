# encoding: utf-8

require File.dirname(__FILE__) + '/../integration_helper'

require 'locomotive/wagon'
require 'locomotive/wagon/cli'

describe 'Locomotive::Wagon::Generators::Page' do

  before                { make_working_copy_of_site(:blog) }
  after                 { remove_working_copy_of_site(:blog) }

  let(:path)            { working_copy_of_site(:blog) }
  let(:fullpath)        { 'new-page' }
  let(:default_locales) { ['en', 'fr'] }
  let(:locales)         { nil }
  let(:page_options)    { { haml: false, locales: locales, default_locales: default_locales } }
  let(:options)         { { 'force_color' => true, 'path' => path, 'quiet' => true }.merge(page_options) }

  subject { Locomotive::Wagon.generate(:page, [fullpath, options.delete('path')], options) }

  describe 'wrong parameters' do

    describe 'empty locales' do

      let(:locales) { '' }

      it { lambda { subject }.should_not raise_error }

    end

  end

  describe 'generating a page' do

    before { subject }

    it 'creates the page in the FS' do
      File.exists?(page_path('new-page')).should be_true
    end

    it 'generates an header in YAML' do
      read_page('new-page').should include <<-EXPECTED
---
title: New-page
EXPECTED
    end

    describe 'other locales' do

      let(:locales) { 'en fr' }

      it 'creates the EN page in the FS' do
        File.exists?(page_path('new-page')).should be_true
      end

      it 'creates the FR page in the FS' do
        File.exists?(page_path('new-page.fr')).should be_true
      end

      describe 'separated by a comma' do

        let(:locales) { 'en,fr' }

        it 'creates the EN page in the FS' do
          File.exists?(page_path('new-page')).should be_true
        end

        it 'creates the FR page in the FS' do
          File.exists?(page_path('new-page.fr')).should be_true
        end

      end

    end

  end

  def page_path(slug)
    File.join(path, 'app', 'views', 'pages', "#{slug}.liquid")
  end

  def read_page(slug)
    File.read(page_path(slug))
  end

end
