<script lang="ts">
	import { ethers, formatUnits } from 'ethers';
	import {
		connected,
		provider,
		chainId,
		allChainsData,
		signer,
		signerAddress,
		contracts
	} from 'ethers-svelte';

	import ConnectIcon from '../Icons/ConnectIcon.svelte';
	import HomeIcon from '../Icons/HomeIcon.svelte';
	import IdentificationIcon from '../Icons/IdentificationIcon.svelte';
	import { onDestroy, onMount } from 'svelte';

	const shortenAddress = (address: string) =>
		address.length >= 16 ? `${address.slice(0, 16)}...` : address;

	signer.subscribe(async () => {
		if ($signer) {
			queriedAddress = $signerAddress;
			await BtnFetchBalanceForQueryAddress();
		}
	});

	let deadAddress: string = '0x0000000000000000000000000000000000000000';

	let queriedAddress: string;
	$: queriedAddress = deadAddress;
	let queriedRawBalance: ethers.BigNumberish;
	$: queriedRawBalance = 0;
	let queriedFormattedBalance: string;
	$: queriedFormattedBalance = '0.0';
	let queriedEnsName: string;
	$: queriedEnsName;

	async function BtnFetchBalanceForQueryAddress() {
		// are we connected to the web3 site with wallet
		if ($provider) {
			console.log(`BtnFetchBalanceForQueryAddress - connected`);

			// reset ens query
			queriedEnsName = "N/A"

			// if queryaddress resolves something from ens, then its an ens, set ens and resolve the address
			let maybeResolvedAddress = await $provider.resolveName(queriedAddress);
			// if we have some value, then we have the ens and the resolved address
			if (maybeResolvedAddress) {
				queriedEnsName = queriedAddress;
				queriedAddress = maybeResolvedAddress;
				console.log(`queriedEnsName: ${queriedEnsName} // queriedAddress: ${queriedAddress}`);
			}
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

<div class="p-6 grid grid-cols-2 gap-6">
	<h2 class="col-span-3 text-2xl font-bold mb-2">Account Information</h2>

	<dl class="col-span-3 grid grid-cols-3 gap-4">
		<div class="flex items-center space-x-4">
			<span class="inline-flex items-center justify-center h-10 w-10 rounded-full">
				<ConnectIcon class="h-6 w-6" />
			</span>
			<div>
				<dt class="text-sm font-medium">IsConnected</dt>
				<dd class="text-sm font-medium">{$connected}</dd>
			</div>
		</div>
		<div class="flex items-center space-x-4">
			<span class="inline-flex items-center justify-center h-10 w-10 rounded-full">
				<HomeIcon class="h-6 w-6" />
			</span>
			<div>
				<dt class="text-sm font-medium">ChainID</dt>
				<dd class="text-sm font-medium">{$chainId}</dd>
			</div>
		</div>
		<div class="flex items-center space-x-4">
			<span class="inline-flex items-center justify-center h-10 w-10 rounded-full">
				<IdentificationIcon class="h-6 w-6" />
			</span>
			<div>
				<dt class="text-sm font-medium">Address</dt>
				<dd class="text-sm font-medium">{shortenAddress($signerAddress ?? deadAddress)}</dd>
			</div>
		</div>
		<div class="flex items-center space-x-4">
			<span class="inline-flex items-center justify-center h-10 w-10 rounded-full">
				<IdentificationIcon class="h-6 w-6" />
			</span>
			<div>
				<dt class="text-sm font-medium">Formatted Balance:</dt>
				<dd class="text-sm font-medium">{queriedFormattedBalance} ETH</dd>
			</div>
		</div>
		<div class="flex items-center space-x-4">
			<span class="inline-flex items-center justify-center h-10 w-10 rounded-full">
				<IdentificationIcon class="h-6 w-6" />
			</span>
			<div>
				<dt class="text-sm font-medium">Raw Balance:</dt>
				<dd class="text-sm font-medium">{queriedRawBalance} GWEI</dd>
			</div>
		</div>
		<div class="flex items-center space-x-4">
			<span class="inline-flex items-center justify-center h-10 w-10 rounded-full">
				<IdentificationIcon class="h-6 w-6" />
			</span>
			<div>
				<dt class="text-sm font-medium">ENS Name</dt>
				<dd class="text-sm font-medium">{queriedEnsName ?? 'N/A'}</dd>
			</div>
		</div>
	</dl>

	<div class="col-span-3 grid grid-cols-7 items-center space-x-4">
		<span class="col-span-1 inline-flex items-center justify-center h-10 w-10 rounded-full">
			<IdentificationIcon class="h-6 w-6" />
			<p class="block text-sm font-medium">Query Balance</p>
		</span>
		<div class="col-span-4 flex flex-col justify-center items-start">

			<input
				id="address"
				bind:value={queriedAddress}
				type="text"
				class="mt-1 block w-full rounded-md focus:ring-2 focus:ring-blue-500"
				placeholder="Enter Address"
			/>
		</div>
		<button
			on:click={BtnFetchBalanceForQueryAddress}
			class="col-span-2 inline-flex items-center justify-center px-4 py-2 border border-transparent text-sm font-medium rounded-md focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500"
		>
			Fetch Balance
		</button>
	</div>
	
	
	
</div>
