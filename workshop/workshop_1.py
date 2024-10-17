from puma.apps.android.whatsapp.whatsapp import WhatsappActions

if __name__ == '__main__':
    """
    This is a very short demo, to make sure eerything is setup correctly.
    Fill in the variables, and then run the main method. 
    """
    device_udid = 'This is the id of tour device, execute "avd devices"'
    recipient = 'the person you will spam (CASE SENSITIVE!)'
    message = 'what do you want to send them?'

    whatsapp = WhatsappActions(device_udid)
    whatsapp.send_message(message_text=message, chat=recipient)
    # You can try to play around with this even more if you want to!
    # Try calling other methods on the whatsapp object
