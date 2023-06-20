//General utility class
public withOut sharing class Utility {
   

    // This method is used to replace needlineBreak with \n in message before sending whatsapp request
    public static string whatsappReplaceLineBreak(string messsage){
        list<string> messageList = string.valueOf(messsage).split(' needlineBreak ');
        string stringToPass = '';
        system.debug('messageList---'+messageList.size());
        for(string msg:messageList){
            system.debug('msg--'+msg);
            stringToPass += msg+'\n';
        }
        return stringToPass;
    }
}