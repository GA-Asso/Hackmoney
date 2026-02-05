export const metadata = {
  title: 'OpenClaw Demo',
  description: 'Sui + ENS Demo',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  )
}
