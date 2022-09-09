include .env

.PHONY: build test snapshot quote

default:; forge fmt && forge build

test:; forge test --fork-url $(FORK_URL) --ffi

quote:; python3 test/python/get_quote.py ${CRV} ${ETH} ${DECIMALS} ${DECIMALS} ${AMOUNT} ${SIDE} ${NETWORK} ${RECEIVER}
