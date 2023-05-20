<script lang="ts">
	import { connected, provider } from 'ethers-svelte';
	import { env } from '$env/dynamic/public';
	import { Table, Paginator } from '@skeletonlabs/skeleton';

	type TransactionTableRow = {
		url: string;
	};

	let latestBlockNumber: number = 0;
	let latestBlock: any = null;
	let transactionsForBlock: any[] = [];
	let hasSubscription = false;

	const shortenTx = (tx: string) => tx.length >= 64 ? `${tx.slice(0, 64)}...` : tx;

	// Reactive Array of Objects holds our list of transactions for latest block
	// IF tableSource becomes  let tableSource = transactionsForBlock
	// THEN page.size is NOT calculated correctly
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
				tableSource = transactionsForBlock.map((tx) => ({
					url: `${env.PUBLIC_BLOCK_EXPLORER_URI}tx/${tx}`
				}));
				// Tell svelte that somethings changed
				tableSource = tableSource;
				// Update reactive pagination length
				page.size = tableSource.length;
			}
		}
	}

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

	function onPageChange(e: CustomEvent): void {
		console.log('event:page', e.detail);
	}
	function onAmountChange(e: CustomEvent): void {
		console.log('event:amount', e.detail);
	}
</script>

<div class="p-4">
	<h2 class="">Block infomation</h2>
	<p class="p-4">
		Block: {latestBlockNumber} <br />
		Gas Used: {latestBlock?.gasUsed ?? 'N/A'} <br />
		Hash: {latestBlock?.hash ?? 'N/A'} <br />
		Miner: {latestBlock?.miner ?? 'N/A'} <br />
		Date Timestamp: {latestBlock?.timestamp
			? new Date(latestBlock.timestamp * 1000).toLocaleString()
			: 'N/A'} <br />
		Unix Timestamp: {latestBlock?.timestamp ?? 'N/A'} <br />
	</p>

<div class="table-container">


	<table class="table table-hover ">
		<thead>
			<tr>
				<th class="text-center">Transaction found in block {latestBlockNumber}</th>
			</tr>
		</thead>
		<tbody>
			{#each paginatedSource as row}
				{#if row}
					<tr>
						<td>
							<a href={row.url} target="_blank" rel="noopener noreferrer">{shortenTx(row.url)}</a>
						</td>
					</tr>
				{:else}
					<tr>
						<td>
							<p>Awaiting next block...</p>
						</td>
					</tr>
				{/if}
			{/each}
		</tbody>
	</table>
	<Paginator class="pt-5" bind:settings={page} />
</div>

</div>