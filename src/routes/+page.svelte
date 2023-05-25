<script lang="ts">
	import { onMount } from 'svelte';
	import { Gradient } from '../lib/gradient/gradient';

	import AccountInfomation from '$lib/components/GridElements/AccountInfomation.svelte';
	import BlockInfomation from '$lib/components/GridElements/BlockInfomation.svelte';
	import ContractReadWrite from '$lib/components/GridElements/ContractReadWrite.svelte';
	// Create your instance

	onMount(async () => {
		const gradient = new Gradient();
		//gradient.initGradientColors()
		// @ts-ignore
		gradient.initGradient('#gradient-canvas');
	});
</script>

<div class="h-screen relative absolute">
	<canvas id="gradient-canvas" class="absolute z-0 opacity-50 h-screen" data-transition-in />

	<div class="absolute w-full text-center grid content-center justify-center">
		<div class="grid grid-cols-3 gap-10 p-10 m-10 auto-rows-auto place-items-center">
			<div class="variant-ghost p-4 self-start">
				<AccountInfomation />
			</div>
			<div class="variant-ghost-primary p-4 self-start">
				<BlockInfomation />
			</div>
			<div class="variant-ghost-secondary p-4 self-start">
				<ContractReadWrite />
			</div>
		</div>
	</div>
</div>
