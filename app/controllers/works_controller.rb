class WorksController < ApplicationController
    before_action :authenticate_admin!, only: [:index, :show, :edit, :update, :destroy, :send_mail]
  
    def index
      @works = Work.order(created_at: "DESC").page(params[:page])
    end
  
    def new
      @work = Work.new
    end
  
    def confirm
      @work = Work.new(work_params)
    end
  
    def thanks
      @work = Work.new(work_params)
      @work.save
      WorkMailer.received_email(@work).deliver # 管理者に通知
      WorkMailer.send_email(@work).deliver # 送信者に通知
    end
  
    def create
      @work = Work.new(work_params)
      @work.save
      redirect_to thanks_works_path
    end
  
    def show
      @work = Work.find_by(params[:id])
  
      @comment = Comment.new
    end
  
    def edit
      @work = Work.find(params[:id])
    end
  
    def destroy
      @work = Work.find(params[:id])
      @work.destroy
      redirect_to works_path, alert:"削除しました"
    end
  
    def update
      @work = Work.find(params[:id])
      if @work.update(work_params)
        redirect_to works_path(@work), alert: "更新しました"
      else
        render 'edit'
      end
    end
  
    def send_mail
      @work = Work.find(params[:id])
      @work.update(send_mail_flag: true)
      WorkMailer.client_email(@work).deliver # 全企業に送信
      redirect_to work_path(@work), alert: "送信しました"
    end

    private
    def work_params
      params.require(:work).permit(
        :name,  #フルネーム
        :tel, #電話番号
        :address,
        :email, #メールアドレス
        :program_histroy, #プログラム歴
        :program_python, #Python歴
        :program_other, #使用可能言語
        :period, #いつから働きたい
        :remarks #要望
      )
    end
  end
  