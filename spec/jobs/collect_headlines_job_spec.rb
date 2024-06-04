# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CollectHeadlinesJob do
  let(:member) { create(:member) }

  before do
    stub_request(:get, member.website_url).to_return(
      body: '<html><body><h1>Title</h1><h2>Subtitle</h2><h3>Heading</h3></body></html>',
      headers: { 'Content-Type' => 'text/html' }
    )
    allow(Rails.logger).to receive(:error)
  end

  it 'enqueues the job' do
    ActiveJob::Base.queue_adapter = :test
    expect do
      described_class.perform_later(member.id)
    end.to have_enqueued_job(described_class).with(member.id).on_queue('default')
  end

  it 'fetches and stores the headlines', :aggregate_failures do
    expect do
      described_class.perform_now(member.id)
    end.to change { member.headlines.count }.by(3)

    expect(member.headlines.pluck(:content)).to include('Title', 'Subtitle', 'Heading')
    expect(member.headlines.pluck(:level)).to include('h1', 'h2', 'h3')
  end

  context 'when there is a network error' do
    before do
      stub_request(:get, member.website_url).to_raise(SocketError.new('Failed to open TCP connection'))
    end

    it 'logs the failure and retries the job', :aggregate_failures do
      expect do
        described_class.perform_now(member.id)
      end.to have_enqueued_job(described_class).with(member.id).on_queue('default')

      expect(Rails.logger).to have_received(:error).with(
        /Error while fetching headlines for Member ID #{member.id}: Failed to open TCP connection/
      )

      expect(member.headlines.count).to eq(0)
    end
  end

  context 'when a parsing error occurs' do
    before do
      allow(Nokogiri::HTML::Document).to receive(:parse)
        .and_raise(Nokogiri::SyntaxError.new('Unexpected parsing error'))
    end

    it 'logs the failure and retries the job', :aggregate_failures do
      expect do
        described_class.perform_now(member.id)
      end.to have_enqueued_job(described_class).with(member.id).on_queue('default')

      expect(Rails.logger).to have_received(:error).with(
        /Error while fetching headlines for Member ID #{member.id}: Unexpected parsing error/
      )
      expect(member.headlines.count).to eq(0)
    end
  end

  context 'when the response is not HTML' do
    before do
      stub_request(:get, member.website_url).to_return(
        body: 'This is not HTML',
        headers: { 'Content-Type' => 'text/plain' }
      )
    end

    it 'does not save any headlines' do
      described_class.perform_now(member.id)

      expect(member.headlines.count).to eq(0)
    end

    it 'doesnt retries the job' do
      expect do
        described_class.perform_now(member.id)
      end.not_to have_enqueued_job(described_class).with(member.id).on_queue('default')
    end
  end

  context 'when no headlines are found' do
    before do
      stub_request(:get, member.website_url).to_return(
        body: '<html><body>No headlines here!</body></html>',
        headers: { 'Content-Type' => 'text/html' }
      )
    end

    it 'does not save any headlines' do
      described_class.perform_now(member.id)

      expect(member.headlines.count).to eq(0)
    end

    it 'doesnt retries the job' do
      expect do
        described_class.perform_now(member.id)
      end.not_to have_enqueued_job(described_class).with(member.id).on_queue('default')
    end
  end

  context 'when the response code is not 200' do
    before do
      stub_request(:get, member.website_url).to_return(
        body: '<html><body><h1>Title</h1><h2>Subtitle</h2><h3>Heading</h3></body></html>',
        status: 404
      )
    end

    it 'does not save any headlines' do
      described_class.perform_now(member.id)

      expect(member.headlines.count).to eq(0)
    end

    it 'doesnt retries the job' do
      expect do
        described_class.perform_now(member.id)
      end.not_to have_enqueued_job(described_class).with(member.id).on_queue('default')
    end
  end
end
