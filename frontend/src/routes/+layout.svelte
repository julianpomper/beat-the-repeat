<script lang='ts'>
	import '../app.css';
	import { goto } from '$app/navigation';
	import { getSession } from '../helper/cookie';
	import { onMount } from 'svelte';

	let installPrompt: any = null;

	onMount(() => {
		const token = getSession();
		if (token.length <= 0) {
			goto('/');
		} else {
			goto('/home');
		}

		window.addEventListener('beforeinstallprompt', (event: any) => {
			console.log('Browser detected app is installable!');
			event.preventDefault();
			installPrompt = event;
		});
	});

	function handleInstallPwa() {
		if (!installPrompt) return;
		installPrompt.prompt();
	}
</script>

<div>
  <main>
	<div class='w-full h-screen'>
	  <div class='bg-gray-900 md:py-16 overflow-y-auto h-full flex flex-col items-center relative'>
		<svg class='absolute z-10 left-0 h-1/4 top-0 w-full opacity-20' xmlns='http://www.w3.org/2000/svg'
			 viewBox='0 0 1440 320' preserveAspectRatio='none'>
		  <path class='fill-black' fill-opacity='1'
				d='M0,192L21.8,176C43.6,160,87,128,131,128C174.5,128,218,160,262,160C305.5,160,349,128,393,133.3C436.4,139,480,181,524,186.7C567.3,192,611,160,655,154.7C698.2,149,742,171,785,197.3C829.1,224,873,256,916,272C960,288,1004,288,1047,272C1090.9,256,1135,224,1178,181.3C1221.8,139,1265,85,1309,64C1352.7,43,1396,53,1418,58.7L1440,64L1440,0L1418.2,0C1396.4,0,1353,0,1309,0C1265.5,0,1222,0,1178,0C1134.5,0,1091,0,1047,0C1003.6,0,960,0,916,0C872.7,0,829,0,785,0C741.8,0,698,0,655,0C610.9,0,567,0,524,0C480,0,436,0,393,0C349.1,0,305,0,262,0C218.2,0,175,0,131,0C87.3,0,44,0,22,0L0,0Z'></path>
		</svg>
		<div
		  class='relative overflow-hidden flex-shrink-0 isolate bg-gray-900 shadow-2xl md:rounded-3xl w-full md:w-auto md:px-32 py-24 px-8'>
		  <svg viewBox='0 0 1024 1024'
			   class='absolute left-3/4 -translate-x-1/2 top-[120%] -translate-y-1/2 -z-10 h-[100rem] w-[100rem] [mask-image:radial-gradient(closest-side,white,transparent)]'>
			<circle cx='512' cy='512' r='512' fill='url(#759c1415-0410-454c-8f7c-9a820de03641)'
					fill-opacity='0.2' />
			<defs>
			  <radialGradient id='759c1415-0410-454c-8f7c-9a820de03641'>
				<stop stop-color='#7775D6' />
				<stop offset='1' stop-color='#E935C1' />
			  </radialGradient>
			</defs>
		  </svg>
		  <slot />
		</div>
		<button on:click={handleInstallPwa} class='mt-8 mb-8 self-center text-white opacity-20'>Install PWA</button>
	  </div>
	</div>
  </main>
</div>
