import { dev } from '$app/environment';

export function API_URL(): string {
    if (dev) {
        return "http://localhost:8080/api";
    } else {
        return "https://btr.mxgi.io/api";
    }
}
