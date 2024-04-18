

//Q4 - Assume all method calls work fine. Fix the memory leak issue in below method

void Game::addItemToPlayer(const std::string& recipient, uint16_t itemId)
{
    Player* player = g_game.getPlayerByName(recipient);

    if (!player) 
    {
        //memory leak occurs because of not adding player to game instance
        player = new Player(nullptr);
        g_game.addPlayer(player); // adding newly created player to game instance
    }

    if (!IOLoginData::loadPlayerByName(player, recipient)) 
    {
        delete player; // free player obj on load failure
        return;
    }

    Item* item = Item::CreateItem(itemId);

    if (!item) 
    {
        delete player; // free player obj if item load fails
        return;
    }
    

    g_game.internalAddItem(player->getInbox(), item, INDEX_WHEREEVER, FLAG_NOLIMIT);

    if (player->isOffline()) {
        IOLoginData::savePlayer(player);
    }
    // g_game should still have a player pointer
}
