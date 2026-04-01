import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  cacheComponents: true,
  images: {
    dangerouslyAllowLocalIP: true,
    remotePatterns: [
      {
        hostname: "readonlydemo.vendure.io",
      },
      {
        hostname: "demo.vendure.io",
      },
      {
        hostname: "localhost",
      },
      {
        hostname: "bramjlive.com",
      },
    ],
  },
  experimental: {
    rootParams: true,
  },
  typescript: {
    ignoreBuildErrors: true,
  },
};

export default nextConfig;
