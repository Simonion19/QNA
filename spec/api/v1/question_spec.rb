require 'rails_helper'

describe 'Question API', type: :request do
  let(:headers) { { 
    "CONTENT_TYPE" => "application/json",
    "ACCEPT"       => "application/json" 
  } }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }
    
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[ title body user_id created_at updated_at ].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end
    end
  end
end