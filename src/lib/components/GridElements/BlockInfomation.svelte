<script lang="ts">
	import { connected, provider, chainId } from 'ethers-svelte';
	import { Paginator } from '@skeletonlabs/skeleton';

	// CommonJS module default export
	import etherscanPkg from '@metamask/etherscan-link';
	const { createExplorerLinkForChain } = etherscanPkg;

	type TransactionTableRow = {
		url: string;
	};

	let latestBlockNumber: number = 0;
	let latestBlock: any = null;
	let transactionsForBlock: any[] = [];
	let hasSubscription = false;

	const shortenTx = (tx: string) => (tx.length >= 64 ? `${tx.slice(0, 64)}...` : tx);

	// Reactive Array of Objects holds our list of transactions for latest block
	let tableSource: Array<TransactionTableRow>;
	$: tableSource = [];

	// Setup block subscription when metamask has been connected
	provider.subscribe(async () => {
		if ($connected && $provider) {
			await updateBlock();
			if (!hasSubscription) {
				console.log(`BlockSubscriptionSetup()`);
				$provider.on('block', updateBlock);
				hasSubscription = true;
			}
		}
	});

	// Sub Fn - On new block, update the state variables for the component
	async function updateBlock() {
		if ($connected && $provider) {
			latestBlockNumber = (await $provider.getBlockNumber()) ?? 1;
			latestBlock = await $provider.getBlock(latestBlockNumber, true);
			console.log(`updateBlock(${latestBlockNumber})`);
			if (latestBlock && latestBlock.transactions) {
				transactionsForBlock = latestBlock.transactions;

				// Update reactive statement
				tableSource = transactionsForBlock.map((txHash) => ({
					url: createExplorerLinkForChain(txHash, `0x` + $chainId)
						? createExplorerLinkForChain(txHash, `0x` + $chainId)
						: 'https://sepolia.etherscan.io/tx/' + txHash // remove when MetaMask/etherscan-link/issues/72 is merged
				}));
				// Tell svelte that somethings changed
				tableSource = tableSource;
				// Update reactive pagination length
				page.size = tableSource.length;
			}
		}
	}

	// Reactive pagination
	$: page = {
		offset: 0,
		limit: 5,
		size: 1,
		amounts: [1, 2, 5, 10]
	};

	$: paginatedSource = tableSource.slice(
		page.offset * page.limit, // start
		page.offset * page.limit + page.limit // end
	);
</script>

<div class="p-4">
	<h2 class="col-span-3 text-3xl font-semibold mb-4">Block information</h2>

	<div class="p-6 mb-6">
		<table class="table-auto w-full justify-center flex">
			<tbody>
				<tr class="text-sm"><td>Block:</td><td>{latestBlockNumber}</td></tr>
				<tr class="text-sm"><td>Gas Used:</td><td>{latestBlock?.gasUsed ?? 'N/A'}</td></tr>
				<tr class="text-sm"><td>Block Hash:</td><td>{latestBlock?.hash ?? 'N/A'}</td></tr>
				<tr class="text-sm"><td>Miner:</td><td>{latestBlock?.miner ?? 'N/A'}</td></tr>
				<tr class="text-sm"
					><td>Date Timestamp:</td><td
						>{latestBlock?.timestamp
							? new Date(latestBlock.timestamp * 1000).toLocaleString()
							: 'N/A'}</td
					></tr
				>
				<tr class="text-sm"><td>Unix Timestamp:</td><td>{latestBlock?.timestamp ?? 'N/A'}</td></tr>
			</tbody>
		</table>
	</div>

	<div class="table">
		<table class="table-auto w-full">
			<thead>
				<tr>
					<th class="px-4 py-2">Transaction found in block {latestBlockNumber}</th>
				</tr>
			</thead>
			<tbody>
				{#each paginatedSource as row}
					{#if row}
						<tr>
							<td class="border px-4 py-2">
								<a
									href={row.url}
									target="_blank"
									rel="noopener noreferrer"
									class="underline text-blue-500">{shortenTx(row.url)}</a
								>
							</td>
						</tr>
					{:else}
						<tr>
							<td class="border px-4 py-2">
								<p>Awaiting next block...</p>
							</td>
						</tr>
					{/if}
				{/each}
			</tbody>
		</table>
		<Paginator class="p-6" bind:settings={page} />
	</div>
</div>
