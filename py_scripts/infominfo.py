from dotenv import load_dotenv, find_dotenv
import telebot
import os
from info_scraper import main

load_dotenv(find_dotenv())
BOT_TOKEN = os.getenv('BOT_TOKEN')
chatID = os.getenv('chatID')
bot_chatID = os.getenv('bot_chatID')
message = main()


def send_msg():
    try:
        bot = telebot.TeleBot(BOT_TOKEN)
        bot.send_message(chatID, f'<pre>{message}</pre>', parse_mode='html')
        return 'Done'
    except ConnectionError:
        print("Failed to establish a new connection")


if __name__ == '__main__':
    send_msg()
