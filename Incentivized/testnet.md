# CrossFi Incentivized Testnet — crossfi-evm-testnet-1

Чтобы поучаствовать в тестнете нам нужно создать CrossFi address и импортировать его в Metamask. Выполняйте все по инструкции, чтобы получить максимально баллов за тестнет.

Используйте как можно меньше токенов для заданий! Потому что одно из заданий будет застейкать токены MPX на валидатора и мы будем стейкать все токены, потому что через 24ч мы запросим еще токенов и будет выполнять задания по кругу, чтобы заработать как можно больше баллов.

Начнем с того, что нам нужно создать CrossFi address. Переходим на сайт - https://test.xficonsole.com/ и нажимаем "Create a new wallet".

![aBmFempwv6](https://github.com/freshe4qa/crossfi/assets/85982863/7731a270-403e-428c-bbe5-b05e64c28efd)

Ставим галочку и нажимаем "Continue".

![EgliivkGT4](https://github.com/freshe4qa/crossfi/assets/85982863/537b612f-a429-40fa-aba9-7c7c6d37f5a0)

Скачиваем файл с фразой в надежное место и нажимаем "Continue".

![fdmpHPo8Iv](https://github.com/freshe4qa/crossfi/assets/85982863/51189b63-3eb7-4fa3-ab64-4131dd4e53ce)

Вписываем фразы по порядку заданому числу и нажимаем "Continue".

![pJ3i4YvFvj](https://github.com/freshe4qa/crossfi/assets/85982863/ab9df26c-caa7-4c52-bdeb-e60196d47d90)

Далее нам нужно запросить токены с крана на этом сайте - https://testpad.xfi.foundation/

Но, от нас требуют подключить Metamask с адресом CrossFi. Для этого арендуем самый дешевый сервер на ubuntu 20.04 и устанавливаем бинарник.

```
sudo apt update && sudo apt upgrade -y
```
```
apt install curl iptables build-essential git wget jq make gcc nano tmux htop nvme-cli pkg-config libssl-dev libleveldb-dev tar clang bsdmainutils ncdu unzip libleveldb-dev -y
```
```
if ! [ -x "$(command -v go)" ]; then
VER="1.21.3"
wget "https://golang.org/dl/go$VER.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$VER.linux-amd64.tar.gz"
rm "go$VER.linux-amd64.tar.gz"
[ ! -f ~/.bash_profile ] && touch ~/.bash_profile
echo "export PATH=$PATH:/usr/local/go/bin:~/go/bin" >> ~/.bash_profile
source $HOME/.bash_profile
[ ! -d ~/go/bin ] && mkdir -p ~/go/bin
fi
```
```
cd $HOME
wget https://github.com/crossfichain/crossfi-node/releases/download/v0.3.0-prebuild3/crossfi-node_0.3.0-prebuild3_linux_amd64.tar.gz && tar -xf crossfi-node_0.3.0-prebuild3_linux_amd64.tar.gz
tar -xvf crossfi-node_0.3.0-prebuild3_linux_amd64.tar.gz
chmod +x $HOME/bin/crossfid
mv $HOME/bin/crossfid $HOME/go/bin
rm -rf crossfi-node_0.3.0-prebuild3_linux_amd64.tar.gz $HOME/bin
```

После чего импортируем CrossFi address с помощью фразы.

```
crossfid keys add wallet --recover
```

Далее получаем ключ, который импортируем в метамаск. После импорта ключа у нас уже будет EVM address. Это 2 адреса, которые связаны между собой. Сохраните ключ в надежное место!

```
crossfid keys unsafe-export-eth-key wallet
```

Далее логинимся через адрес, который мы добавили на этот сайт - https://testpad.xfi.foundation/

После того как зашли на сайт нажимаем "Claim". Нас попросит привязать Telegram аккаунт, после этого мы сможем раз в 24ч запрашивать токены, чтобы выполнять задания.

![djbqCbWoug](https://github.com/freshe4qa/crossfi/assets/85982863/f40c6c7e-287e-4318-85b5-5cf304e1e0e0)

Перейдем к выполнению заданий в этой вкладке - https://testpad.xfi.foundation/earn-xft

1) Send MPX or XFI to the Cosmos part of the console

Переходим в console - https://test.xficonsole.com/wallet?type=cosmos

И отправляем XFI на любой crossfi address, его Вы можете найти в дискорде проекта, либо отправить другу.

![T0mW3FuKO9](https://github.com/freshe4qa/crossfi/assets/85982863/27998a39-9bbb-43ba-84be-c50c58521e83)

Далее в разделе "Operations History" в одной из вкладок(Transactions\Token Transfers) будет Ваша транзакция, копируем hash транзакции и отправляем его в первое задание.

![PDL8BudeNV](https://github.com/freshe4qa/crossfi/assets/85982863/291163e8-4d42-44af-ad89-898b6e81fa11)

![yeFObXWxJq](https://github.com/freshe4qa/crossfi/assets/85982863/10ffa85f-3509-4ddb-8bad-94adfb3f1768)

![fu1DGMyA01](https://github.com/freshe4qa/crossfi/assets/85982863/f582eecb-ba6a-4ab3-a4d2-3eceabbc4613)

2) Send XFI to the EVM part of the console

Такое же задание как и первое, только отправляем теперь XFI токен на EVM address.

После этого копируем hash этой транзакции и отправляем во второе задание.

![QhjIMBwsoM](https://github.com/freshe4qa/crossfi/assets/85982863/8c96d850-fa8e-471d-8fd9-c38bce7b37f6)

![p1rZ2EKhfX](https://github.com/freshe4qa/crossfi/assets/85982863/3818a72d-6db8-4793-bfb0-93548f1e0483)

3) Send MPX and/or XFI to different addresses in one transaction

Здесь от нас требуется отправить XFI токен на 2 адреса одной транзакцией.

![38cCDXHIdt](https://github.com/freshe4qa/crossfi/assets/85982863/083d64dc-9bbe-47f6-8d71-a01db0d16e5d)

![6gzYo1Rgr7](https://github.com/freshe4qa/crossfi/assets/85982863/03441634-ea00-4224-af0b-375c67a48fa7)

После этого копируем hash этой транзакции и отправляем в третье задание.

4) Send XFI and MPX in one transaction

Здесь от нас требуется отправить токены XFI и MPX на 1 адрес одной транзакцией. Отправляем чуть-чуть токенов, так как они нам еще понадобятся.

![UGchzJkLfC](https://github.com/freshe4qa/crossfi/assets/85982863/8dad5254-a66b-4941-b715-a470c270c15a)

![Xvx2d8ssUo](https://github.com/freshe4qa/crossfi/assets/85982863/5ecbad53-e6e1-42fa-b6d5-7e002153e5df)

После этого копируем hash этой транзакции и отправляем в четвертое задание.

5) Delegate MPX to a validator

Здесь нам нужно застейкать токен MPX на валидатора. В знак благодарности за проделанный гайд, просто застейкать на нашего валидатора Crypton. Далее я покажу как нас найти.

Переходим во вкладку "Staking" и нажимаем "Bond".

![k8ENKdCM0W](https://github.com/freshe4qa/crossfi/assets/85982863/85998d48-2ce7-4d46-92f0-34f092eebbad)

После чего у нас будут две вкладки "Active validators" и "Inactive validators". Если нас нет в первой вкладке, значит мы еще находимся во второй. Чуть ниже будет выбранный Вами валидатор. Вписываем кол-во токенов как на скрине и подтверждаем транзакцию.

![BGK4hZhXbp](https://github.com/freshe4qa/crossfi/assets/85982863/c1e04a8b-fc50-4e83-9b29-d6fd644db7c2)

На этом выполнение заданий окончено. Каждые 24ч Вы можете запрашивать токены и повторять действия. Чем чаще Вы будете запрашивать токены и выполнять задания, тем больше баллов Вы получите.
