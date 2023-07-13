<script lang='ts'>
	import spotify from '../lib/images/spotify.png';
	import { API_URL } from '../helper/constants';
	import Button from '$lib/components/Button.svelte';
</script>

<svelte:head>
	<title>Beat the Repeat</title>
	<meta name='description' content='Get started with Beat the Repeat' />
</svelte:head>

<div class='max-w-md flex flex-col items-start justify-center'>
	<h2 class='text-5xl font-bold text-white'>
		Beat the Repeat
	</h2>
	<p class='mt-4 text-xl text-gray-300'>
		Never ever listen twice to a song in<br> your playlist again!
	</p>
	<Button class='mt-10'>
		<img alt='Spotify logo'
				 class='w-6 h-6'
				 src={spotify}>
		<a href={API_URL()}
			 class='text-sm font-bold text-gray-900 shadow-sm'>
			GET STARTED
		</a>
	</Button>
</div>
