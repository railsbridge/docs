require 'spec_helper'
require "titleizer"

describe Titleizer do
  it 'uppercases rvm' do
    Titleizer.title_for_page('rvm_is_a_thing').should == 'RVM Is A Thing'
  end

  it 'uppercases osx as OS X' do
    Titleizer.title_for_page('osx_ive_never_heard_of_it').should == 'OS X Ive Never Heard Of It'
  end

  it 'uppercases ssh' do
    Titleizer.title_for_page('ssh_into_all_the_things').should == 'SSH Into All The Things'
  end

  it 'upcases CRUD, even if it is already uppercase' do
    Titleizer.title_for_page('CRUD_with_scaffolding').should == 'CRUD With Scaffolding'
  end

  it 'uppercases dvd' do
    Titleizer.title_for_page('why_cant_my_vhs_play_this_dvd').should == 'Why Cant My Vhs Play This DVD'
  end

  it 'uppercases html' do
    Titleizer.title_for_page('whats_the_deal_with_html').should == 'Whats The Deal With HTML'
  end

  it 'capitalizes sentences' do
    Titleizer.title_for_page('sandwich_parade_on_tuesday').should == 'Sandwich Parade On Tuesday'
  end
end
