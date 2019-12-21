class ChangeownerMailer < ApplicationMailer
    def changeowner_mail(owner)
        @changeowner = owner
        mail to: @changeowner.owner.email, subject: "管理者が変更されました"
    end
end


