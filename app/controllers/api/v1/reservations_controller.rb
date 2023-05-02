class Api::V1::ReservationsController < Api::V1::ApplicationController
  before_action :set_reservation, only: %i[show edit update destroy]
  before_action :authenticate_request

  # GET /reservations or /reservations.json
  def index
    @reservations = Reservation.includes(:car).all
    render json: { reservations: @reservations.as_json(methods:
    %i[car_make car_image car_model car_year car_daily_rate]) }
  end

  # GET /reservations/1 or /reservations/1.json
  def show; end

  # GET /reservations/new
  def new
    @reservation = Reservation.new
  end

  # GET /reservations/1/edit
  def edit; end

  # POST /reservations or /reservations.json
  def create
    @reservation = Reservation.new(reservation_params)
    @reservation.user_id = @current_user.id

    if @reservation.save
      render json: { reservation: @reservation, success: true, message: 'Car reserved successfully!' },
             status: :created
    else
      render json: { success: false, message: @reservation.errors.full_messages.join(', '),
                     status: :unprocessable_entity }
    end
  end

  # PATCH/PUT /reservations/1 or /reservations/1.json
  def update
    respond_to do |format|
      if @reservation.update(reservation_params)
        format.html { redirect_to reservation_url(@reservation), notice: 'Reservation was successfully updated.' }
        format.json { render :show, status: :ok, location: @reservation }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reservations/1 or /reservations/1.json
  def destroy
    @reservation.destroy

    respond_to do |format|
      format.html { redirect_to reservations_url, notice: 'Reservation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_reservation
    @reservation = Reservation.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def reservation_params
    params.require(:reservation).permit(:reservation_date, :due_date, :car_id)
  end
end
