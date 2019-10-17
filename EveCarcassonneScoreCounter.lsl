///
/// Evelins Carcassonne Score Counter
/// Copyright by ofcourse Evelin ;)
///
/// This script watches the chat for score announcements
/// and adds them to a score list.
///  

integer chatListenHandler;
string carcassonneName = "Carcassonne Table";

list scoreList = [];


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
    
    if(llGetSubString(scoreEntry, 0, 0) == "+")
        score = (integer)llGetSubString(scoreEntry, 1, 5);
    else
        score = -(integer)llGetSubString(scoreEntry, 1, 5);    
        
    addScore(llList2String(tokens, 1), score);
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
        llSay(0, "Sorry, the list is empty");
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
    
    llSay(0, "  The winner is " + winner + " with " + (string)scoreWinner + " points!");
    llSay(0, "  ------------------------");
}


DumpList()
{
     llOwnerSay(llList2CSV(scoreList));
}


///
/// Increments the users score. 
///
addScore(string username, integer score)
{
    llOwnerSay("Adding score of " + (string)score + " to user " + username);
     
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
        if(channel != 0 || name != carcassonneName)
            return;
            
        processMessage(message);
    }
    

    touch_start(integer total_number)
    {
        PrintScoreList();
    }
}
