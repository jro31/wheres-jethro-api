module Api
  module V1
    class CheckInsController < Api::V1::BaseController
      # GET /api/v1/check_ins
      def index
        begin
          @check_ins = policy_scope(CheckIn).order(created_at: :desc)
          render json: {
            check_ins: CheckInsRepresenter.new(@check_ins).as_json
          }, status: :ok
        rescue => e
          @skip_after_action = true
          render json: {
            error_message: e.message
          }, status: :not_found
        end
      end

      # POST /api/v1/check_ins
      def create
        # TODO
      end
    end
  end
end
