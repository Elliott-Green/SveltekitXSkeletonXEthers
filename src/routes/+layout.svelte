<script lang="ts">
	import '@skeletonlabs/skeleton/themes/theme-crimson.css';
	import '@skeletonlabs/skeleton/styles/skeleton.css';
	import '../app.postcss';

	import { AppBar, AppShell, AppRail, AppRailTile, Toast } from '@skeletonlabs/skeleton';

	import { defaultEvmStores as evm } from 'ethers-svelte';
	import { page } from '$app/stores';
	import { onMount } from 'svelte';
	import { derived } from 'svelte/store';

	import Header from '../lib/components/Navigation/Header.svelte';
	import { abi as GREETER_ABI } from '../lib/abi/Greeter.json';

	const selected = derived(page, ($page) => $page.url.pathname);
	const GREETER_SEPOLIA: string = '0x9dEC4CcBebA62bc53E55FEeB7891C797321AB15B';

	onMount(async () => {
		// @ts-ignore
		await evm.attachContract('greeter', GREETER_SEPOLIA, GREETER_ABI);
	});
</script>

<AppShell>
	<svelte:fragment slot="header">
		<Header />
	</svelte:fragment>
	<slot />
</AppShell>
<Toast />
