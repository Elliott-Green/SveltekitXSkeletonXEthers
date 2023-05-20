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
        gradient.initGradient("#gradient-canvas");
	});
</script>
<div class="h-screen relative absolute">

    <canvas id="gradient-canvas" class="absolute z-0 opacity-50 h-screen" data-transition-in></canvas>

    <div class="absolute h-full w-full text-center grid content-center">
        <div class="grid grid-cols-3 gap-10 h-screen p-10 m-10">
            <div class="variant-ghost p-4 ">
                <AccountInfomation />
            </div>
            <div class="variant-ghost-primary p-4">
                <BlockInfomation />
            </div>
            <div class="variant-ghost-secondary p-4">
                <ContractReadWrite />
            </div>
        </div>
        
    </div>

</div>
