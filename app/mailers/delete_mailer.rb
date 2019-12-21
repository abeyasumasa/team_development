class DeleteMailer < ApplicationMailer
    def delete_mail(email)
        @email = email
        
        mail to: @email, subject: "アジェンダを削除しました！"
      end
end
