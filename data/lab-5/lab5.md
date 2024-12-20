# Лабораторная Работа 5
_де Джофрой Мишель, Белунин Дмитрий Вадимович, Кирдин Даниил Игоревич_

## Часть 1. Настройка инфраструктуры

<img width="1223" alt="image" src="https://github.com/user-attachments/assets/5409315d-3649-4896-9d31-d6cd16aae56b" />

## Часть 2. Настройка статической маршрутизации

```
enable
configure terminal
ip route 192.168.0.0 255.255.255.224 192.168.0.34 # LAN 1
ip route 192.168.0.96 255.255.255.224 192.168.0.66 # LAN 4
ip route 192.168.0.128 255.255.255.224 192.168.0.67 # LAN 5
```

## Часть 3. Настройка динамической маршрутизации 

<img width="1085" alt="image" src="https://github.com/user-attachments/assets/e7e7533a-87aa-4716-b610-05c7505e88dc" />

```
enable
configure terminal
router rip
version 2
network 192.168.1.32
network 192.168.1.64
```

<img width="684" alt="image" src="https://github.com/user-attachments/assets/2b742bd1-f3b8-4fd6-8170-96bb0c4b6484" />

## Часть 4. Создание дополнительных сетей & Часть 5. Объединение сетей


<img width="612" alt="image" src="https://github.com/user-attachments/assets/8c32bcaf-82f3-42af-9851-62bca3b54af9" />

## AS 100
```
enable
configure terminal
ip route 192.168.0.0 255.255.255.0 Null0
router bgp 100
neighbor 10.0.0.10 remote-as 101
neighbor 10.0.0.2 remote-as 102
neighbor 10.0.0.6 remote-as 103
network 192.168.0.0 mask 255.255.0.0
```

## AS 101
```
enable
configure terminal
ip route 192.168.1.0 255.255.255.0 Null0
router rip
passive-interface  FastEthernet6/0
passive-interface  FastEthernet7/0
passive-interface  FastEthernet8/0
default-information originate
exit
router bgp 101
neighbor 10.0.0.9 remote-as 100
neighbor 10.0.0.14 remote-as 102
neighbor 10.0.0.18 remote-as 103
network 192.168.1.0 mask 255.255.255.0
```
## AS 102
```
  10.0.0.0/30 is subnetted, 2 subnets
C     10.0.0.0 is directly connected, FastEthernet1/0
C    10.0.0.12 is directly connected, FastEthernet6/0

B 192.168.0.0/24 [20/0] via 10.0.0.1, 00:00:00
B 192.168.1.0/24 [20/0] via 10.0.0.13, 00:00:00
C 192.168.2.0/24 is directly connected, FastEthernet0/0
B 192.168.3.0/24 [20/0] via 10.0.0.13, 00:00:00
```
## AS 103
```
  10.0.0.0/30 is subnetted, 2 subnets
C    10.0.0.4 is directly connected, FastEthernet1/0
C    10.0.0.16 is directly connected, FastEthernet6/0

B 192.168.0.0/24 [20/0] via 10.0.0.5, 00:00:00
B 192.168.1.0/24 [20/0] via 10.0.0.17, 00:00:00
B 192.168.2.0/24 [20/0] via 10.0.0.17, 00:00:00
C 192.168.3.0/24 is directly connected, FastEthernet0/0
```

```
Router>show ip bgp summary
BGP router identifier 192.168.0.65, local AS number 100
BGP table version is 30, main routing table version 6
10 network entries using 1320 bytes of memory
10 path entries using 520 bytes of memory
9/9 BGP path/bestpath attribute entries using 1656 bytes of memory
4 BGP AS-PATH entries using 96 bytes of memory
0 BGP route-map cache entries using O bytes of memory
0 BGP filter-list cache entries using 0 bytes of memory
Bitfield cache entries: current 1 (at peak 1) using 32 bytes of memory
BGP using 3624 total bytes of memory
BGP activity 4/0 prefixes, 10/0 paths, scan interval 60 secs

Neighbor   V  AS    MsgRcvd   MsgSent  TblVer  InQ  OutQ  Up/Down    State/PfxRcd
10.0.0.2   4  102    174      154      30      0    0     00:26:27   4
10.0.0.6   4  103    168      151      30      0    0     00:26:27   4
10.0.0.10  4  101    58       168      30      0    0     00:28:11   4

```


# Вопросы

## Вопрос 1
_Поясните результаты, полученные в Части 5, п.8_

```
C: \>tracert 192.168.2.2
Tracing route to 192.168.2.2 over a maximum of 30 hops:

  1    0 ms      0 ms      0 ms      192.168.1.1
  2    0 ms      0 ms      0 ms      192.168.1.34
  3    0 ms      0 ms      0 ms      10.0.0.14
  4    0 ms      0 ms      0 ms      192.168.2.2

Trace complete.

C: \>tracert 192.168.2.2

Tracing route to 192.168.2.2 over a maximum of 30 hops:

  1    0 ms      0 ms      0 ms      192.168.1.1
  2    0 ms      0 ms      0 ms      192.168.1.34
  3    0 ms      0 ms      0 ms      10.0.0.9
  4    0 ms      0 ms      0 ms      10.0.0.2
  5    0 ms      0 ms      0 ms      192.168.2.2
```

После отключения линии между AS 101 и AS 102 маршруты корректно проходят через соединение AS 100 из-за того, что в BGP хранятся все пути соединения.

## Вопрос 2
Как, имея доступ к консоли маршрутизатора узнать, что проходят обновления информации bgp?
show ip bgp summary
show ip bgp neighbors
bgp log-neighbor-changes

## Вопрос 3
Какие различия в настройке и работе протоколов bgp и rip вы отметили по ходу выполнения работы?
RIP: простая настройка, автоматически обнаруживает соседей, внутренняя маршрутизация, для небольших сетей.
BGP: требует усидчивости и дополнительные данные для настройки, требует ручного указания соседей, внешняя маршрутизация, для крупных сетей Интернет масштаба без ограничения по хопам.
