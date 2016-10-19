#!/usr/bin/env python2



import Skype4Py
import time
import re

class SkypeBot(object):
    def __init__(self):
        self.skype = Skype4Py.Skype(Events=self)
        self.skype.FriendlyName = "Skype Bot"
        self.skype.Attach()

    def OnlineStatus(self, user, status):
        print(user, status)
        return

    def AttachmentStatus(self, status):
        print('attach:', status)
        if status == Skype4Py.apiAttachAvailable:
            self.skype.Attach()

    def MessageStatus(self, msg, status):
        if status == Skype4Py.cmsReceived:
            if msg.Chat.Type in (Skype4Py.chatTypeDialog, Skype4Py.chatTypeLegacyDialog):
                for regexp, target in self.commands.items():
                    match = re.match(regexp, msg.Body, re.IGNORECASE)
                    if match:
                        msg.MarkAsSeen()
                        reply = target(self, *match.groups())
                        if reply:
                            msg.Chat.SendMessage(reply)
                        break

    def CallStatus(self, call, status):
        print(call, status, call._GetPartnerHandle())
        allow_peer = 'yat-sen'
        if status == 'RINGING':
            if call._GetPartnerHandle() == allow_peer:
                print('auto answer...')
                call.Answer()
            else:
                print('reject call...', call._GetPartnerHandle())
                call.Finish()
        elif status == 'INPROGRESS':
            if call._GetPartnerHandle() == allow_peer:
                call.StartVideoSend()
                # self.skype._SetMute('OFF')
        return

    def cmd_userstatus(self, status):
        if status:
            try:
                self.skype.ChangeUserStatus(status)
            except Skype4Py.SkypeError, e:
                return str(e)
        return 'Current status: %s' % self.skype.CurrentUserStatus

    def cmd_credit(self):
        return self.skype.CurrentUserProfile.BalanceToText

    commands = {
        "@userstatus *(.*)": cmd_userstatus,
        "@credit$": cmd_credit
    }

if __name__ == "__main__":
    bot = SkypeBot()

    while True:
        time.sleep(0.1)
