<script lang="ts">
	import { ethers, formatUnits } from 'ethers';
	import { connected, provider, chainId, signer, signerAddress } from 'ethers-svelte';
	import { focusTrap } from '@skeletonlabs/skeleton';

	import ConnectIcon from '../Icons/ConnectIcon.svelte';
	import HomeIcon from '../Icons/HomeIcon.svelte';
	import IdentificationIcon from '../Icons/IdentificationIcon.svelte';
	import MoneyIcon from '../Icons/MoneyIcon.svelte';
	import SearchIcon from '../Icons/SearchIcon.svelte';

	const shortenAddress = (address: string) =>
		address.length >= 16 ? `${address.slice(0, 16)}...` : address;

	let deadAddress: string = '0x0000000000000000000000000000000000000000';
	let isFocused: boolean = true;

	let queriedAddress: string;
	$: queriedAddress = '';
	let queriedRawBalance: ethers.BigNumberish;
	$: queriedRawBalance = 0;
	let queriedFormattedBalance: string;
	$: queriedFormattedBalance = '0.0';
	let queriedEnsName: string;
	$: queriedEnsName;

	// Once wallet is connected and we have a signer, put their address into the queryAddress and then query it
	provider.subscribe(async () => {
		if ($provider) {
			queriedAddress = $signerAddress;
			await BtnFetchBalanceForQueryAddress();
		}
	});

	// Queries ENS name for an address
	async function BtnFetchBalanceForQueryAddress() {
		// are we connected to the web3 site with wallet
		if ($provider) {
			console.log(`BtnFetchBalanceForQueryAddress - connected`);

			// reset ens query
			queriedEnsName = 'N/A';
			// only query on eth mainnet
			if ($chainId == 1) {
				// if queryaddress resolves something from ens, then its an ens, set ens and resolve the address
				let maybeResolvedAddress = await $provider.resolveName(queriedAddress);
				// if we have some value, then we have the ens and the resolved address
				if (maybeResolvedAddress) {
					queriedEnsName = queriedAddress;
					queriedAddress = maybeResolvedAddress;
					console.log(`queriedEnsName: ${queriedEnsName} // queriedAddress: ${queriedAddress}`);
				}
			} else console.log(`Warning - Not the right network to query ENS`);

			// if this is a valid address then get the balance
			if (ethers.isAddress(queriedAddress)) {
				queriedRawBalance = (await $signer.provider?.getBalance(queriedAddress)) ?? BigInt(0);
				queriedFormattedBalance = formatUnits(
					ethers.parseUnits(queriedRawBalance.toString(), 'wei'),
					'ether'
				);
			} else {
				console.error(
					`ERROR - BtnFetchBalanceForQueryAddress - queriedAddress: ${queriedAddress} is not a valid address`
				);
			}
		}
	}
</script>


<div class="p-6 grid grid-cols-1">
    <h2 class="col-span-full text-2xl font-bold mb-2">Account Information</h2>
	<dl class="grid grid-cols-1 md:grid-cols-2 gap-4 sm:gap-2">
        <div class="flex items-center space-x-2 sm:space-x-4">
            <span class="inline-flex items-center justify-center h-10 w-10 rounded-full">
                <ConnectIcon class={'h-6 w-6'} />
            </span>
            <div class="h-10">
                <dt class="text-sm">IsConnected</dt>
                <dd class="text-xs">{$connected}</dd>
            </div>
        </div>
		<div class="flex items-center space-x-2 sm:space-x-4">
			<span class="inline-flex items-center justify-center h-10 w-10 rounded-full">
				<HomeIcon class="h-6 w-6" />
			</span>
			<div class="h-10">
				<dt class="text-sm">ChainID</dt>
				<dd class="text-xs">{$chainId}</dd>
			</div>
		</div>
		<div class="flex items-center space-x-2 sm:space-x-4">
			<span class="inline-flex items-center justify-center h-10 w-10 rounded-full">
				<IdentificationIcon class="h-6 w-6" />
			</span>
			<div class="h-10">
				<dt class="text-sm">Address</dt>
				<dd class="text-xs">{shortenAddress($signerAddress ?? deadAddress)}</dd>
			</div>
		</div>
		<div class="flex items-center space-x-2 sm:space-x-4">
			<span class="inline-flex items-center justify-center h-10 w-10 rounded-full">
				<MoneyIcon class="h-6 w-6" />
			</span>
			<div class="h-10">
				<dt class="text-sm">Formatted Balance:</dt>
				<dd class="text-xs">{queriedFormattedBalance} ETH</dd>
			</div>
		</div>
		<div class="flex items-center space-x-2 sm:space-x-4">
			<span class="inline-flex items-center justify-center h-10 w-10 rounded-full">
				<MoneyIcon class="h-6 w-6" />
			</span>
			<div class="h-10">
				<dt class="text-sm">Raw Balance:</dt>
				<dd class="text-xs">{queriedRawBalance} GWEI</dd>
			</div>
		</div>
		<div class="flex items-center space-x-2 sm:space-x-4">
			<span class="inline-flex items-center justify-center h-10 w-10 rounded-full">
				<IdentificationIcon class="h-6 w-6" />
			</span>
			<div class="h-10">
				<dt class="text-sm">ENS Name</dt>
				<dd class="text-xs">{queriedEnsName ?? 'N/A'}</dd>
			</div>
		</div>
	</dl>

	<h2 class="col-span-full text-2xl font-bold pt-2">Query Balance</h2>

    <form
        use:focusTrap={isFocused}
        class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4 items-center"
    >
        <div class="col-span-full sm:col-span-1 lg:col-span-2 flex flex-col justify-center items-start">
            <input
                id="address"
                bind:value={queriedAddress}
                type="text"
                class="mt-1 block w-full py-2 px-3 rounded-md focus:ring-2 focus:ring-blue-500"
                placeholder="Query an address or ENS"
            />
        </div>

        <button
            on:click={BtnFetchBalanceForQueryAddress}
            class="btn variant-filled col-span-full sm:col-span-1 lg:col-span-1 inline-flex items-center justify-center px-4 py-2 rounded-md"
        >
            <SearchIcon class={'h-6 w-6 mr-2'} />
            Fetch Balance
        </button>
    </form>
</div>