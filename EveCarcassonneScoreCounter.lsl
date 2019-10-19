///
/// Evelins Carcassonne Score Counter
/// Copyright by ofcourse Evelin ;)
///
/// Check out the Github page for documentation:
/// https://github.com/evelinsl/EveCarcassonneCounter
///
/// This script watches the chat for score announcements
/// and adds them to a score list.
///  

integer chatListenHandler;
string carcassonneName = "Carcassonne Table";

list scoreList = [];


///
/// Handles the messages send from the owner.
///
processOwnerMessage(string message)
{
    list tokens = llParseString2List(message, [" "], []);
    
    if(llGetListLength(tokens) < 1) 
        return;    
        
    string command = llToLower(llList2String(tokens, 0));
    
    if(command == "!reset")  
    {
        llSay(0, "Clearing the score list...");
        
        scoreList = [];
        PrintScoreList();
        
        return;
    }
    
    if(command == "!alter")
    {
        integer score = parseScore(llList2String(tokens, 1));
        string username = llDumpList2String(llList2List(tokens, 2, 4), " ");
        
        llSay(0, "SCORE: " + (string)score + " username: " + username);
        
        if(score == 0 || username == "")
        {
            llSay(0, "Computer says no");
            return;
        }
        
        addScore(username, score, 1);
    }
    
    if(command == "!scores")
        PrintScoreList();
        
    if(command == "!dump")
        DumpList();
}


///
/// Tokenizes and parses the message from the Carcassonne table.
///
processMessage(string message)
{
    list tokens = llParseString2List(message, [" coins to ", "."], []);
    
    if(llGetListLength(tokens) != 2) 
        return;
    
    integer score = 0;    
    string scoreEntry = llList2String(tokens, 0); 
        
    addScore(llList2String(tokens, 1), parseScore(scoreEntry), 0);
}


///
/// Converts an string scor representation to a integer.
/// Valid formats are "2", "+2" or "-2"; 
///
integer parseScore(string score)
{
    if(llGetSubString(score, 0, 0) == "-")
        return -(integer)llGetSubString(score, 1, 5);
        
    if(llGetSubString(score, 0, 0) == "+")
        return (integer)llGetSubString(score, 1, 5);
       
    return (integer)score;
}


///
/// Adds some spacing at the front of the score 
///
string PadScore(integer score)
{
    string strScore = (string)score;
    integer add = 3 - llStringLength(strScore);
    
    if(add > 0)
    {
        integer index;
        
        for(index = add; index >= 1; index--)
            strScore = " " + strScore;
    } 
    
    return strScore;    
}


///
/// Prints the current scorelist
///
PrintScoreList()
{
    integer listLength = llGetListLength(scoreList);
    
    if(listLength == 0)
    {
        llSay(0, "The scorelist is empty");
        return;
    }

    integer index;    
    string winner = "";
    integer scoreWinner = 0;
    
    llSay(0, "  ------------------------");
    
    for(index = 0; index < listLength; index++)
    {
        if(index % 2 == 0)
        {
            integer score = (integer)llList2String(scoreList, index + 1);
            
            if(score > scoreWinner)
            {
                scoreWinner = score;
                winner = llList2String(scoreList, index);
            }
            
            llSay(0, "\t" + PadScore(score) + "\t" + llList2String(scoreList, index));
        } 
    }
    
    llSay(0, "  " + winner + " has manage to collect the most coins so far!");
    llSay(0, "  ------------------------");
}


DumpList()
{
     llSay(0, llList2CSV(scoreList));
}


///
/// Increments or decrements the users score. 
///
addScore(string username, integer score, integer mustExist) 
{
    if(score == 0)
        return;
        
    if(score > 0)    
        llSay(0, "Adding " + (string)score + " coins to player " + username);
    else
        llSay(0, "Removing " + (string)score + " coins from player " + username);       
     
    integer listLength = llGetListLength(scoreList);
    integer index;
    
    for(index = 0; index < listLength; index++)
    {
        if(index % 2 == 0 && llList2String(scoreList, index) == username)
        {
            // Update the score 
            
            integer currentScore = (integer)llList2String(scoreList, index + 1);
            scoreList = llListReplaceList(scoreList, [currentScore + score], index + 1, index + 1);
            return;
        } 
    }
    
    if(mustExist)
    {
        llSay(0, 
            "Sorry, but there is no player with the name " 
            + username 
            + ". You can only alter scores of players currently in the playerlist."
        );
        return;
    }
    
    // The user was not found in the list, so add it
    
    scoreList = scoreList + [username, score];
}


default
{
    
    state_entry()
    {
        chatListenHandler = llListen(0, "", "", "");
    }
    
    
    listen(integer channel, string name, key id, string message)
    {   
        if(channel != 0)
            return;
            
        if(id == llGetOwner())
            processOwnerMessage(message);
        else if(name == carcassonneName) 
            processMessage(message);
    }
    

    touch_start(integer total_number)
    {
        PrintScoreList();
    }
}
