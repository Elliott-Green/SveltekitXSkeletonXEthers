<script>
	// Your selected Skeleton theme:
	import '@skeletonlabs/skeleton/themes/theme-modern.css';

	// This contains the bulk of Skeletons required styles:
	// NOTE: this will be renamed skeleton.css in the v2.x release.
	import '@skeletonlabs/skeleton/styles/skeleton.css';

	// Finally, your application's global stylesheet (sometimes labeled 'app.css')
	import '../app.postcss';

	import '../app.postcss';

	import { AppBar, AppShell, AppRail, AppRailTile } from '@skeletonlabs/skeleton';

	import { page } from '$app/stores';
	import { derived } from 'svelte/store';

	import Header from '../lib/components/Navigation/Header.svelte';

	const selected = derived(page, ($page) => $page.url.pathname);

	
</script>

<AppShell>
	<svelte:fragment slot="header">

			<Header />
	
	</svelte:fragment>


	<slot />

	<svelte:fragment slot="pageFooter">Page Footer</svelte:fragment>
</AppShell>
