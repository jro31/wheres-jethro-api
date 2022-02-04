module Api
  module V1
    class CheckInsController < Api::V1::BaseController
      # GET /api/v1/check_ins
      def index
        begin
          @check_ins = policy_scope(CheckIn).order(created_at: :desc).limit(params[:limit])
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
        begin
          @check_in = CheckIn.new(check_in_params)
          authorize @check_in

          @check_in.save!

          render json: {
            check_in: CheckInRepresenter.new(@check_in).as_json
          }, status: :created
        rescue Pundit::NotAuthorizedError
          super
        rescue ActiveRecord::RecordInvalid => e
          render json: {
            error_message: e.message.split(':')&.last&.strip || 'Something went wrong'
          }, status: :unprocessable_entity
        rescue => e
          @skip_after_action = true
          render json: {
            error_message: e.message
          }, status: :unprocessable_entity
        end
      end

      private

      def check_in_params
        params.require(:check_in).permit(:name, :description, :latitude, :longitude, :accuracy, :icon, :time_zone, :photo)
      end
    end
  end
end
