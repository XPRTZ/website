import { useId } from 'react'
import clsx from 'clsx'

export function Logomark({
  invert = false,
  filled = false,
  ...props
}: React.ComponentPropsWithoutRef<'svg'> & {
  invert?: boolean
  filled?: boolean
}) {
  let id = useId()

  return (
    <svg viewBox="0 0 32 32" aria-hidden="true" {...props}>
      <rect
        clipPath={`url(#${id}-clip)`}
        className={clsx(
          'h-8 transition-all duration-300',
          invert ? 'fill-white' : 'fill-xprtz-600',
          filled ? 'w-8' : 'w-0 group-hover/logo:w-8',
        )}
      />
      <use
        href={`#${id}-path`}
        className={invert ? 'stroke-white' : 'stroke-xprtz-600'}
        fill="none"
        strokeWidth="1.5"
      />
      <defs>
        <path
          id={`${id}-path`}
          d="M3.25 26v.75H7c1.305 0 2.384-.21 3.346-.627.96-.415 1.763-1.02 2.536-1.752.695-.657 1.39-1.443 2.152-2.306l.233-.263c.864-.975 1.843-2.068 3.071-3.266 1.209-1.18 2.881-1.786 4.621-1.786h5.791V5.25H25c-1.305 0-2.384.21-3.346.627-.96.415-1.763 1.02-2.536 1.751-.695.658-1.39 1.444-2.152 2.307l-.233.263c-.864.975-1.843 2.068-3.071 3.266-1.209 1.18-2.881 1.786-4.621 1.786H3.25V26Z"
        />
        <clipPath id={`${id}-clip`}>
          <use href={`#${id}-path`} />
        </clipPath>
      </defs>
    </svg>
  )
}

export function Logo({
  className,
  invert = false,
  filled = false,
  fillOnHover = false,
  ...props
}: React.ComponentPropsWithoutRef<'svg'> & {
  invert?: boolean
  filled?: boolean
  fillOnHover?: boolean
}) {
  return (
    <svg
      viewBox="0 0 213.7 213.7"
      aria-hidden="true"
      enableBackground={`new 0 0 213.7 213.7`}
      className={clsx(fillOnHover && 'group/logo', className)}
      {...props}
    >
      {/* <Logomark
        preserveAspectRatio="xMinYMid meet"
        invert={invert}
        filled={filled}
      /> */}
      <g>
        <linearGradient
          id="SVGID_1_"
          gradientUnits="userSpaceOnUse"
          x1="55.5921"
          y1="235.987"
          x2="92.4418"
          y2="199.999"
          gradientTransform="matrix(1 0 0 -1 0 277.2756)"
        >
          <stop offset="0" stopColor="#FFFFFF" stopOpacity="0" />
          <stop offset="1" stopColor="#333333" />
        </linearGradient>
        <polygon fill="url(SVGID_1_)" points="48,47.9 77.6,47.9 99.5,69.6 84.6,84.5  " />
      </g>
      <linearGradient
        id="SVGID_2_"
        gradientUnits="userSpaceOnUse"
        x1="140.0862"
        y1="121.7768"
        x2="99.356"
        y2="164.3733"
        gradientTransform="matrix(1 0 0 -1 0 277.2756)"
      >
        <stop offset="0" stopColor="#FFFFFF" stopOpacity="0" />
        <stop offset="1" stopColor="#333333" />
      </linearGradient>
      <polygon fill="url(SVGID_2_)" points="165.8,165.8 136.1,165.8 92,121.8 106.8,106.9 " />
      <path className='fill-xprtz-600' d="M213.7,106.9c0,59-47.8,106.9-106.9,106.9S0,165.9,0,106.9S47.8,0,106.9,0S213.7,47.8,213.7,106.9z M48,165.8  h29.8L99.4,144l-14.9-14.8L48,165.8z M99.5,69.6L77.6,47.9H48l36.7,36.6L99.5,69.6z M106.8,106.9L165.7,48h-29.8L92,92l0,0l0,0v29.8  l44.1,43.9h29.7L106.8,106.9z" />
    </svg>
  )
}
