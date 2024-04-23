// Q4 Assume all method calls work fine. Fix the memory leak issue in below method

void Game::addItemToPlayer(const std::string& recipient, uint16_t itemId)
{
	Player* player = g_game.getPlayerByName(recipient);

	if (!player) {
		// the following line was the source of memory leak. Any object allocated memory using the "new" keyword must also be expilicity 
		// deallocated using the "delete" keyword. Deleting player object at all exit points of the function should solve the memory leak.
		player = new Player(nullptr); 
		if (!IOLoginData::loadPlayerByName(player, recipient)) {
			delete player;
			return;
		}
	}

	Item* item = Item::CreateItem(itemId);
	if (!item) {
		// add condition to make sure the player object being deleted is the one newly created in the function
		if(!g_game.getPlayerByName(recipient)) 
			delete player;
		
		return;
	}

	g_game.internalAddItem(player->getInbox(), item, INDEX_WHEREEVER, FLAG_NOLIMIT);

	if (player->isOffline()) {
		IOLoginData::savePlayer(player);
	}

	if(!g_game.getPlayerByName(recipient))
			delete player;
}
