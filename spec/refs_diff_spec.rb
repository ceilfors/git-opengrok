require 'spec_helper'

describe 'refs_diff' do
  [
    {
      before: {},
      after: { :'refs/remotes/origin/master' => '1' },
      expected: ['refs/remotes/origin/master']
    }, {
      before: { :'refs/remotes/origin/master' => '1' },
      after: { :'refs/remotes/origin/feature' => '1' },
      expected: ['refs/remotes/origin/feature']
    }, {
      before: { :'refs/remotes/origin/master' => '1' },
      after: { :'refs/remotes/origin/master' => '1', :'refs/remotes/origin/feature' => '1' },
      expected: ['refs/remotes/origin/feature']
    }, {
      before: { :'refs/remotes/origin/master' => '1' },
      after: {
        :'refs/remotes/origin/master' => '1',
        :'refs/remotes/origin/feature' => '1',
        :'refs/remotes/origin/bug' => '1'
      },
      expected: ['refs/remotes/origin/bug', 'refs/remotes/origin/feature']
    }
  ].each do |example|
    it 'detects new references' do
      ref_diff = Daun::RefsDiff.new(example[:before], example[:after])

      expect(ref_diff.added).to match_array(example[:expected])
    end
  end

  [
    {
      before: {},
      after: { :'refs/remotes/origin/master' => '1' },
      type: :tags,
      expected: []
    }, {
      before: {},
      after: { :'refs/tags/1.0' => '1', :'refs/remotes/origin/master' => 1 },
      type: :tags,
      expected: ['refs/tags/1.0']
    }, {
      before: {},
      after: { :'refs/tags/1.0' => '1', :'refs/remotes/origin/master' => 1 },
      type: :remotes,
      expected: ['refs/remotes/origin/master']
    }
  ].each do |example|
    it 'filters added references by type' do
      ref_diff = Daun::RefsDiff.new(example[:before], example[:after])

      expect(ref_diff.added(example[:type])).to match_array(example[:expected])
    end
  end

  [
    {
      before: {},
      after: { :'refs/remotes/origin/master' => '1' },
      expected: []
    },
    {
      before: { :'refs/remotes/origin/master' => '1' },
      after: { :'refs/remotes/origin/master' => '1' },
      expected: []
    },
    {
      before: { :'refs/remotes/origin/master' => '1' },
      after: { :'refs/remotes/origin/master' => '2' },
      expected: ['refs/remotes/origin/master']
    }, {
      before: { :'refs/tags/1.0' => '1', :'refs/remotes/origin/master' => '1' },
      after: { :'refs/tags/1.0' => '1', :'refs/remotes/origin/master' => '2' },
      expected: ['refs/remotes/origin/master']
    }
  ].each do |example|
    it 'detects updated references' do
      ref_diff = Daun::RefsDiff.new(example[:before], example[:after])

      expect(ref_diff.updated).to match_array(example[:expected])
    end
  end

  [
    {
      before: { :'refs/tags/1.0' => '1', :'refs/remotes/origin/master' => '1' },
      after: { :'refs/tags/1.0' => '2', :'refs/remotes/origin/master' => '2' },
      type: :tags,
      expected: ['refs/tags/1.0']
    }, {
      before: { :'refs/tags/1.0' => '1', :'refs/remotes/origin/master' => '1' },
      after: { :'refs/tags/1.0' => '1', :'refs/remotes/origin/master' => '2' },
      type: :remotes,
      expected: ['refs/remotes/origin/master']
    }
  ].each do |example|
    it 'filters updated references by type' do
      ref_diff = Daun::RefsDiff.new(example[:before], example[:after])

      expect(ref_diff.updated(example[:type])).to match_array(example[:expected])
    end
  end

  [
    {
      before: { :'refs/remotes/origin/master' => '1' },
      after: {},
      expected: ['refs/remotes/origin/master']
    }, {
      before: { :'refs/remotes/origin/master' => '1' },
      after: { :'refs/remotes/origin/feature' => '1' },
      expected: ['refs/remotes/origin/master']
    }, {
      before: {},
      after: { :'refs/remotes/origin/master' => '1', :'refs/remotes/origin/feature' => '1' },
      expected: []
    }, {
      before: {
        :'refs/remotes/origin/master' => '1',
        :'refs/remotes/origin/feature' => '1',
        :'refs/remotes/origin/bug' => '1'
      },
      after: { :'refs/remotes/origin/master' => '1' },
      expected: ['refs/remotes/origin/bug', 'refs/remotes/origin/feature']
    }
  ].each do |example|
    it 'detects deleted references' do
      ref_diff = Daun::RefsDiff.new(example[:before], example[:after])

      expect(ref_diff.deleted).to match_array(example[:expected])
    end
  end

  [
    {
      before: { :'refs/tags/1.0' => '1', :'refs/remotes/origin/master' => '1' },
      after: {},
      type: :tags,
      expected: ['refs/tags/1.0']
    }, {
      before: {
        :'refs/remotes/origin/master' => '1',
        :'refs/remotes/origin/feature' => '1',
        :'refs/remotes/origin/bug' => '1'
      },
      after: { :'refs/remotes/origin/master' => '1' },
      type: :remotes,
      expected: ['refs/remotes/origin/bug', 'refs/remotes/origin/feature']
    }
  ].each do |example|
    it 'filters deleted references by type' do
      ref_diff = Daun::RefsDiff.new(example[:before], example[:after])

      expect(ref_diff.deleted(example[:type])).to match_array(example[:expected])
    end
  end
end
