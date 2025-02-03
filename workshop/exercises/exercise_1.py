from puma.apps.android.teleguard.teleguard import TeleguardActions

if __name__ == '__main__':
    """
    For the first exercise, we will use existing functionality to learn how to use Puma. We will send a message in chat
    app Teleguard. 
    
    Set up Teleguard
    ----------------
    1. Open the app
    2. Tap Register
    3. Enter a username
    4. Agree to terms and tap register

    Your Teleguard ID is displayed in a "chat" with Teleguard, and can be shared with other users to message one another.
    
    Fill in the variables, and then run the main method.
    """

    device_udid = '32131JEHN38079' # This is the id of tour device, execute `adb devices`
    recipient_id = '' # Teleguard ID of the person you will spam
    recipient_username = '' # Username of the person you will spam
    message = '' # Message to send

    teleguard = TeleguardActions(device_udid)
    teleguard.add_contact(recipient_id)
    teleguard.send_message(message_text=message, chat=recipient)
    # You can try to play around with this even more if you want to!
    # Try calling other methods on the whatsapp object

if __name__ == '__main__':
