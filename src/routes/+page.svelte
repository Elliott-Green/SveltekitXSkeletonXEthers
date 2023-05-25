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

    <div class="absolute w-full h-full flex justify-center xs:pt-60">
        <div class="grid grid-cols-1 sm:grid-cols-3 p-5 m-5 auto-rows-auto place-items-start gap-10 md:gap-8">
            <div class="variant-ghost p-2">
                <AccountInfomation />
            </div>
            <div class="variant-ghost-primary p-2">
                <BlockInfomation />
            </div>
            <div class="variant-ghost-secondary p-2 ">
                <ContractReadWrite />
            </div>
        </div>
    </div>
</div>
