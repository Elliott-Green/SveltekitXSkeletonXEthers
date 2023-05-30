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
	import AccountInfomation from '$lib/components/GridElements/AccountInfomation.svelte';
	import BlockInfomation from '$lib/components/GridElements/BlockInfomation.svelte';
	import ContractReadWrite from '$lib/components/GridElements/ContractReadWrite.svelte';
</script>
<div class="w-full h-full flex justify-center xs:pt-60">
	<div
		class="grid grid-cols-1 lg:grid-cols-2 xl:grid-cols-3 p-5 m-5 auto-rows-auto place-items-start gap-10 md:gap-8 sm:justify-items-center"
	>
		<div class="variant-ghost p-2">
			<AccountInfomation />
		</div>
		<div class="variant-ghost-primary p-2">
			<BlockInfomation />
		</div>
		<div class="variant-ghost-secondary p-2">
			<ContractReadWrite />
		</div>
	</div>
</div>
