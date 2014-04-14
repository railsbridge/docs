require 'spec_helper'
require "titleizer"

describe Titleizer do
  it 'uppercases rvm' do
    expect(Titleizer.title_for_page('rvm_is_a_thing')).to eq('RVM Is A Thing')
  end

  it 'uppercases osx as OS X' do
    expect(Titleizer.title_for_page('osx_ive_never_heard_of_it')).to eq('OS X Ive Never Heard Of It')
  end

  it 'uppercases ssh' do
    expect(Titleizer.title_for_page('ssh_into_all_the_things')).to eq('SSH Into All The Things')
  end

  it 'upcases CRUD, even if it is already uppercase' do
    expect(Titleizer.title_for_page('CRUD_with_scaffolding')).to eq('CRUD With Scaffolding')
  end

  it 'uppercases php as PHP' do
    expect(Titleizer.title_for_page('php_is_what_we_do')).to eq ('PHP Is What We Do')
  end

  it 'uppercases dvd' do
    expect(Titleizer.title_for_page('why_cant_my_vhs_play_this_dvd')).to eq('Why Cant My Vhs Play This DVD')
  end

  it 'uppercases html' do
    expect(Titleizer.title_for_page('whats_the_deal_with_html')).to eq('Whats The Deal With HTML')
  end

  it 'uppercases url as URL' do
    expect(Titleizer.title_for_page('this_is_a_pretty_url')).to eq ('This Is A Pretty URL')
  end

  it 'capitalizes sentences' do
    expect(Titleizer.title_for_page('sandwich_parade_on_tuesday')).to eq('Sandwich Parade On Tuesday')
  end

  it 'transforms docs to Get Started' do
    expect(Titleizer.title_for_page('docs')).to eq('Get Started')
  end

  it 'transforms urls to URLs' do
    expect(Titleizer.title_for_page('urls')).to eq('URLs')
  end
end
