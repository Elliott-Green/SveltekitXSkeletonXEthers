<script lang="ts">
	import { onMount } from 'svelte';
	import {
		defaultEvmStores as evm,
		connected,
		chainId,
		contracts,
		getChainDataByChainId,
		provider
	} from 'ethers-svelte';
	import { toastStore } from '@skeletonlabs/skeleton';
	import type { ToastSettings } from '@skeletonlabs/skeleton';
	import { focusTrap } from '@skeletonlabs/skeleton';
	import WriteIcon from '../Icons/WriteIcon.svelte';

	// CommonJS module default export
	import etherscanPkg from '@metamask/etherscan-link';
	const { createExplorerLinkForChain } = etherscanPkg;

	let isFocused: boolean = true;

	async function TriggerTransactionToast(success: boolean, txURL: string) {
		console.log(txURL);
		let toastText = success ? 'Transaction success!' : 'Transaction error!';
		let buttonClass = success ? 'variant-filled-success' : 'variant-filled-error';

		const dynamicToast: ToastSettings = {
			message: 'Message contains a unique action.',
			autohide: false,
			background: buttonClass,
			action: {
				label: toastText,
				response: () => window.open(txURL, '_blank')
			}
		};
		toastStore.trigger(dynamicToast);
	}

	const SEPOLIA_CHAINID = '11155111';

	// The field the user can change
	$: userGreeting = '';

	// The current greeting values as a reactive statement
	$: currentGreeting = '';

	// When the component is mounted, the layout sets up the contracts if the wallet is connected, so this will be true on refreshes.
	onMount(async () => {
		await GetStateValue();
	});

	// Once the component has been setup and then user then logins, we can run the same get logic, this will be true when they connect for the first time
	provider.subscribe(async () => {
		await GetStateValue();
	});

	// Get the state value
	async function GetStateValue() {
		if ($connected) {
			const { chainId } = await $provider.getNetwork(); // using $chainID doesn't seem to work here...
			if (chainId == SEPOLIA_CHAINID) {
				currentGreeting = await $contracts.greeter.greet();
				console.log(`ContractReadWrite - Loading value ${currentGreeting}`);
			} else console.log(`ContractReadWrite - Not fetching value for non sepolia chainID`);
		} else console.log(`ContractReadWrite - Not fetching value for unconnected wallet`);
	}

	// Write a new greeting to contract & refresh if successful
	async function SetNewGreeting() {
		// Did the user set something?
		if (userGreeting) {
			// Set the greeting
			const greetTx = await $contracts.greeter.setGreeting(userGreeting);
			// Await a successful response
			let txReceipt = await greetTx.wait(1);
			if (txReceipt.status == 1) {
				let newGreeting = await $contracts.greeter.greet(); // get new value
				currentGreeting = newGreeting; // store new value
				console.log(
					`generating URL ${
						createExplorerLinkForChain(greetTx.hash, `0x` + $chainId) ??
						'https://sepolia.etherscan.io/tx/' + greetTx.hash
					}`
				);
				TriggerTransactionToast(
					true,
					createExplorerLinkForChain(greetTx.hash, `0x` + $chainId)
						? createExplorerLinkForChain(greetTx, `0x` + $chainId)
						: 'https://sepolia.etherscan.io/tx/' + greetTx.hash // remove when MetaMask/etherscan-link/issues/72 is merged
				);
				console.log(`SetNewGreeting - TxSuccessful - currentGreeting:${currentGreeting}`);
			} else {
				TriggerTransactionToast(
					false,
					createExplorerLinkForChain(greetTx.hash, `0x` + $chainId)
						? createExplorerLinkForChain(greetTx.hash, `0x` + $chainId)
						: 'https://sepolia.etherscan.io/tx/' + greetTx.hash // remove when MetaMask/etherscan-link/issues/72 is merged
				);
				console.error(`SetNewGreeting - TxFail - Status:${greetTx.status}`);
			}
		} else console.error(`SetNewGreeting - GreetingSet - No greeting set!`);
	}
</script>


<div class="p-6 grid grid-cols-1">
    <h2 class="col-span-full text-2xl font-bold mb-2">Contract ABI Read/Write</h2>
	<p class="md:w-96">
		This section is proving that we can read, write and stay updated with the state field 'Greet'
		from the Greeter contract. <a
			class="text-blue-600 hover:text-blue-800 underline"
			href="https://sepolia.etherscan.io/address/0x9dec4ccbeba62bc53e55feeb7891c797321ab15b"
			target="_blank">Take a look at the contract on the Sepolia testnet</a
		>
	</p>
	

	<div class="pt-4 md:pt-6">
		{#if $connected}
			{#if $chainId != SEPOLIA_CHAINID}
				<div class="">
					<p class="text-sm md:text-base mb-2">
						You are connected to the wrong network: {getChainDataByChainId($chainId).name}.
					</p>

					<p class="text-sm md:text-base mb-2">
						Please connect to the network {getChainDataByChainId(SEPOLIA_CHAINID).name} for the $contract
						store demo.
					</p>
					<p class="text-sm md:text-base mb-2">
						You can add additional testnet connections to metamask via (Account Icon / Settings /
						Advanced / Show Test Networks)
					</p>
				</div>
			{:else if $contracts.greeter}
				<h3 class="text-xl md:text-3xl font-semibold mb-2">Read State</h3>

				<p class="text-base md:text-lg mb-4 text-center">The current greeting is: {currentGreeting}</p>
				<h3 class="text-xl md:text-3xl font-semibold mb-2">Write State</h3>

				<form use:focusTrap={isFocused} class="grid grid-cols-1 md:grid-cols-12 gap-4 items-center">
					<div class="md:col-span-8 flex flex-col justify-center items-start">
						<input
							id="address"
							bind:value={userGreeting}
							type="text"
							class="mt-1 block w-full py-2 px-3 rounded-md focus:ring-2 focus:ring-blue-500"
							placeholder="Enter a new greeting"
						/>
					</div>

					<button
						class="btn variant-filled inline-flex items-center justify-center px-2 md:px-4 py-2 rounded-md mt-2 md:mt-0 md:col-span-4"
						on:click={SetNewGreeting}
						><WriteIcon class={'h-6 w-6 mr-2'} />
						Set greeting</button
					>
				</form>
			{/if}
		{:else}
			<div class="">
				<p class="text-sm md:text-base mb-2">
					Please connect to the network {getChainDataByChainId(SEPOLIA_CHAINID).name} for the $contract
					store demo.
				</p>
				<p class="text-sm md:text-base mb-2">
					You can add additional testnet connections to metamask via (Account Icon / Settings /
					Advanced / Show Test Networks)
				</p>
			</div>
		{/if}
	</div>
</div>
