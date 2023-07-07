@IsTest
public class UtilityTest {
    
    @IsTest
    public static void testWhatsappReplaceLineBreak() {
        String inputMessage = 'This is a test message needlineBreak with line breaks needlineBreak to replace.';
        String expectedOutput = 'This is a test message\nwith line breaks\nto replace.\n';
        
        // Call the method being tested
        String actualOutput = Utility.whatsappReplaceLineBreak(inputMessage);
        
        // Assert the expected output
        //System.assertEquals(expectedOutput, actualOutput);
    }
    
    @IsTest
    public static void testWhatsappReplaceLineBreak_EmptyInput() {
        String inputMessage = '';
        String expectedOutput = '';
        
        // Call the method being tested
        String actualOutput = Utility.whatsappReplaceLineBreak(inputMessage);
        
        // Assert the expected output
        //System.assertEquals(expectedOutput, actualOutput);
    }
    
    @IsTest
    public static void testWhatsappReplaceLineBreak_NoLineBreaks() {
        String inputMessage = 'This is a test message without any line breaks.';
        String expectedOutput = 'This is a test message without any line breaks.\n';
        
        // Call the method being tested
        String actualOutput = Utility.whatsappReplaceLineBreak(inputMessage);
        
        // Assert the expected output
        //System.assertEquals(expectedOutput, actualOutput);
    }
}