import { Context, Telegraf } from "telegraf"

const bot = new Telegraf(process.env.BOT_TOKEN)
bot.command('start', (ctx) => ctx.reply('Welcome!'))
bot.command('oldschool', (ctx) => ctx.reply('Hello'))
bot.command('hipster', Telegraf.reply('λ'))
console.log("Launching: ")
bot.launch()