class EventsController < ApplicationController
	before_action :authenticate_user!, only:[:new, :edit, :create, :update, :destroy]
	before_action :find_event, only:[:show, :join, :quit]
	def find_event
		@event = Event.find(params[:id])
	end
	def index
		@events = Event.all
	end

	def show
	end

	def new 
		@event = Event.new
	end

	def create
		@event = current_user.events.new(event_params)
		if @event.save
			redirect_to events_path
			flash[:success] = "活動發起成功"
		else
			render :new
		end
	end

	def edit
		@event = current_user.events.find(params[:id])
	end

	def update
		@event = current_user.events.find(params[:id])
		if @event.update(event_params)
			redirect_to events_path
			flash[:success] = "活動修改成功"
		else
			render :edit
		end
	end

	def destroy
		@event = current_user.events.find(params[:id])
		@event.destroy
		redirect_to events_path
		flash[:danger] = "活動已刪除"
	end

	def join
	end

	def quit
	end

	private

	def event_params
		params.require(:event).permit(:name, :nature, :description, :max_sign_up_number, :min_sign_up_number, :sign_up_begin, :sign_up_end, :start, :over)
	end

	
end