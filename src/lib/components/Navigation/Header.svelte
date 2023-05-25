<script lang="ts">
	import {
		connected,
		provider,
		chainId,
		chainData,
		signer,
		signerAddress,
		contracts
	} from 'ethers-svelte';
	import { ethers } from 'ethers';
	import { defaultEvmStores as evm } from 'ethers-svelte';
	import { Jazzicon } from 'ethers-svelte/components';
	import { AppBar } from '@skeletonlabs/skeleton';
	import ConnectIcon from '../Icons/ConnectIcon.svelte';

	async function ConnectWallet() {
		console.log(`connectWallet - ${!$connected}`);
		if (!$connected) {
			console.log(`connectWallet - Attempting to Connect`);
			try {
				await evm.setProvider();
			} catch (error) {
				console.error(`Failed to connect: ${error}`);
			}
			console.log(`connectWallet - Connected!`);
		} else {
			console.log(`connectWallet - Attempting to Connect`);
			try {
				await evm.disconnect();
			} catch (error) {
				console.error(`Failed to connect: ${error}`);
			}
			console.log(`connectWallet - Disconnected!`);
		}
	}

	const shortenAddress = (address: string) => `${address.slice(0, 6)}...${address.slice(-4)}`;
</script>

<AppBar gridColumns="grid-cols-3" slotDefault="place-self-center" slotTrail="place-content-end">
	<svelte:fragment slot="lead"
		><p class="font-bold">Sveltekit X Skeleton X Ethers</p></svelte:fragment
	>

	<svelte:fragment slot="trail">
		{#if !$connected}
			<button on:click={ConnectWallet} class="btn variant-filled">
				<span class="pl-1 pr-1">	<ConnectIcon class={"h-6 w-6"} /></span>
				<span class="pl-1 pr-1">Connect Wallet</span>
			</button>
		{:else}
			<button on:click={ConnectWallet} class="btn variant-ghost">
				<span class="pl-1 pr-1"> <Jazzicon address={$signerAddress} size={20} /></span>
				<span class="pl-1 pr-1">{shortenAddress($signerAddress)}</span>
			</button>
		{/if}
	</svelte:fragment>
</AppBar>
