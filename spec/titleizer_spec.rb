require 'spec_helper'
require "titleizer"

describe Titleizer do
  it 'uppercases acronyms' do
    {
      'rvm_is_a_thing' => 'RVM Is A Thing',
      'ssh_into_all_the_things' => 'SSH Into All The Things',
      'CRUD_with_scaffolding' => 'CRUD With Scaffolding',
      'why_cant_my_vhs_play_this_dvd' => 'Why Cant My Vhs Play This DVD',
      'whats_the_deal_with_html' => 'Whats The Deal With HTML'
    }.each do |initial, expected|
      expect(Titleizer.title_for_page(initial)).to eq(expected)
    end
  end

  it 'uppercases osx as OS X' do
    expect(Titleizer.title_for_page('osx_ive_never_heard_of_it')).to eq('OS X Ive Never Heard Of It')
  end

  it 'uppercases argv' do
    expect(Titleizer.title_for_page('argv')).to eq('ARGV')
  end

  it 'keeps irb lowercase' do
    expect(Titleizer.title_for_page('irb_as_a_service')).to eq('irb As A Service')
  end

  it 'capitalizes sentences' do
    expect(Titleizer.title_for_page('sandwich_parade_on_tuesday')).to eq('Sandwich Parade On Tuesday')
  end
end
