pragma solidity ^0.4.23;

/*
                                                                                       (   )
               $$$$$$$$\ $$$$$$$\   $$$$$$\  $$\   $$\                               (    )
               \__$$  __|$$  __$$\ $$  __$$\ $$$\  $$ |                                (    )
                  $$ |   $$ |  $$ |$$ /  $$ |$$$$\ $$ |                              (    )
                  $$ |   $$$$$$$  |$$ |  $$ |$$ $$\$$ |                                )  )
                  $$ |   $$  __$$< $$ |  $$ |$$ \$$$$ |                                (  (
                  $$ |   $$ |  $$ |$$ |  $$ |$$ |\$$$ |                                (_)
                  $$ |   $$ |  $$ | $$$$$$  |$$ | \$$ |                        ________[_]________
                  \__|   \__|  \__| \______/ \__|  \__|                       /\        ______    \
                                                                             //_\       \    /\    \
$$\    $$\ $$$$$$\ $$\       $$\        $$$$$$\   $$$$$$\  $$$$$$$$\        //___\       \__/  \    \
$$ |   $$ |\_$$  _|$$ |      $$ |      $$  __$$\ $$  __$$\ $$  _____|      //_____\       \ |[]|     \
$$ |   $$ |  $$ |  $$ |      $$ |      $$ /  $$ |$$ /  \__|$$ |           //_______\       \|__|      \
\$$\  $$  |  $$ |  $$ |      $$ |      $$$$$$$$ |$$ |$$$$\ $$$$$\        /XXXXXXXXXX\                  \
 \$$\$$  /   $$ |  $$ |      $$ |      $$  __$$ |$$ |\_$$ |$$  __|      /_I_II  I__I_\__________________\
  \$$$  /    $$ |  $$ |      $$ |      $$ |  $$ |$$ |  $$ |$$ |           I_I|  I__I_____[]_|_[]_____I
   \$  /   $$$$$$\ $$$$$$$$\ $$$$$$$$\ $$ |  $$ |\$$$$$$  |$$$$$$$$\      I II__I  I     XXXXXXX     I
    \_/    \______|\________|\________|\__|  \__| \______/ \________|  ~~~~~"   "~~~~~~~~~~~~~~~~~~~~~~~~
                                                                           "     "

Tron Village - economic strategy based on Tron Network blockchain

Web                   -  https://tronvillage.com
Discord               -  https://discordapp.com/invite/U9rsj4V
Telegram chat         -  https://t.me/TronVillage
Telegram channel      -  https://t.me/TronVillageInfo
Bitcointalk[EN]       -  https://bitcointalk.org/index.php?topic=5092491.0
Bitcointalk[RU]       -  https://bitcointalk.org/index.php?topic=5092478.0

*/

library SafeMath {

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b);

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0);
        uint256 c = a / b;

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        uint256 c = a - b;

        return c;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);

        return c;
    }

}

contract TronVillage {

    using SafeMath for uint256;

    uint constant COIN_PRICE = 40000;
    uint constant TYPES_FACTORIES = 6;
    uint constant PERIOD = 60 minutes;

    uint[TYPES_FACTORIES] prices = [3000, 11750, 44500, 155000, 470000, 950000];
    uint[TYPES_FACTORIES] profit = [4, 16, 62, 220, 680, 1400];

    uint public totalPlayers;
    uint public totalFactories;
    uint public totalPayout;

    address owner;
    address manager;

    struct Player {
        uint coinsForBuy;
        uint coinsForSale;
        uint time;
        uint[TYPES_FACTORIES] factories;
    }

    mapping(address => Player) public players;

    constructor(address _owner, address _manager) public {
        owner = _owner;
        manager = _manager;
    }

    function deposit() public payable {
        require(msg.value >= COIN_PRICE);

        Player storage player = players[msg.sender];
        player.coinsForBuy = player.coinsForBuy.add(msg.value.div(COIN_PRICE));

        if (player.time == 0) {
            player.time = now;
            totalPlayers++;
        }
    }

    function buy(uint _type, uint _number) public {
        require(_type < TYPES_FACTORIES && _number > 0);
        collect(msg.sender);

        uint paymentCoins = prices[_type].mul(_number);
        Player storage player = players[msg.sender];

        require(paymentCoins <= player.coinsForBuy.add(player.coinsForSale));

        if (paymentCoins <= player.coinsForBuy) {
            player.coinsForBuy = player.coinsForBuy.sub(paymentCoins);
        } else {
            player.coinsForSale = player.coinsForSale.add(player.coinsForBuy).sub(paymentCoins);
            player.coinsForBuy = 0;
        }

        player.factories[_type] = player.factories[_type].add(_number);
        players[owner].coinsForSale = players[owner].coinsForSale.add( paymentCoins.mul(75).div(1000) );
        players[manager].coinsForSale = players[manager].coinsForSale.add( paymentCoins.mul(25).div(1000) );

        totalFactories = totalFactories.add(_number);
    }

    function withdraw(uint _coins) public {
        require(_coins > 0);
        collect(msg.sender);
        require(_coins <= players[msg.sender].coinsForSale);

        players[msg.sender].coinsForSale = players[msg.sender].coinsForSale.sub(_coins);
        transfer(msg.sender, _coins.mul(COIN_PRICE));
    }

    function collect(address _addr) internal {
        Player storage player = players[_addr];
        require(player.time > 0);

        uint hoursPassed = ( now.sub(player.time) ).div(PERIOD);
        if (hoursPassed > 0) {
            uint hourlyProfit;
            for (uint i = 0; i < TYPES_FACTORIES; i++) {
                hourlyProfit = hourlyProfit.add( player.factories[i].mul(profit[i]) );
            }
            uint collectCoins = hoursPassed.mul(hourlyProfit);
            player.coinsForBuy = player.coinsForBuy.add( collectCoins.div(2) );
            player.coinsForSale = player.coinsForSale.add( collectCoins.div(2) );
            player.time = player.time.add( hoursPassed.mul(PERIOD) );
        }
    }

    function transfer(address _receiver, uint _amount) internal {
        if (_amount > 0 && _receiver != address(0)) {
            uint contractBalance = address(this).balance;
            if (contractBalance > 0) {
                uint payout = _amount > contractBalance ? contractBalance : _amount;
                totalPayout = totalPayout.add(payout);
                msg.sender.transfer(payout); // msg.sender == _receiver
            }
        }
    }

    function factoriesOf(address _addr) public view returns (uint[TYPES_FACTORIES]) {
        return players[_addr].factories;
    }

}
