import type { Position } from "./Types";

interface IJobListings {
  companyGreeting: string;
  jobDescription0: string;
  jobDescription1: string;
  jobDescription2: string;
  positions: Position[];
  contactGreeting: string;
  contactDescription: string;
  addressLink: string;
  addressPart0: string;
  addressPart1: string;
  phone0Link: string;
  phone0: string;
  phone0Suffix: string;
  phone1Link: string;
  phone1: string;
  phone1Suffix: string;
  mailtoLink: string;
  email: string;
  whatYouGetGreeting: string;
  whatYouGetList: string[];
  whatYouBringGreeting: string;
  whatYouBringList: string[];
}

export default function JobListings(
  {
    companyGreeting,
    jobDescription0,
    jobDescription1,
    jobDescription2,
    positions,
    contactGreeting,
    contactDescription,
    addressLink,
    addressPart0,
    addressPart1,
    phone0Link,
    phone0,
    phone0Suffix,
    phone1Link,
    phone1,
    phone1Suffix,
    mailtoLink,
    email,
    whatYouGetGreeting,
    whatYouGetList,
    whatYouBringGreeting,
    whatYouBringList
  }: IJobListings
) {
  return (
    <div className="bg-white pt-32">
      <div className="mx-auto max-w-7xl px-6 lg:px-8">
        <div className="mx-auto flex max-w-2xl flex-col items-end justify-between gap-16 lg:mx-0 lg:max-w-none lg:flex-row">
          <div className="w-full lg:max-w-lg lg:flex-auto">
            <h2 className="text-3xl font-bold tracking-tight text-primary-900 sm:text-4xl">{companyGreeting}</h2>
            <p className="mt-6 text-xl leading-8 text-gray-600">{jobDescription0}</p>
            <p className="mt-6 text-xl leading-8 text-gray-600">{jobDescription1}</p>
            <img
              src="https://images.unsplash.com/photo-1606857521015-7f9fcf423740?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1344&h=1104&q=80"
              alt=""
              className="mt-16 aspect-[6/5] w-full rounded-2xl bg-gray-50 object-cover lg:aspect-auto lg:h-[34.5rem]"/>
          </div>
          <div className="w-full lg:max-w-xl lg:flex-auto">
            <p className="mb-6 text-xl leading-8 text-gray-600 pb-8">{jobDescription2}</p>
            <ul className="-my-8 divide-y divide-gray-100">
              {positions.map((position) => (
                <li key={position.id} className="py-4">
                  <dl className="relative flex flex-wrap gap-x-3">
                    <dd className="w-full flex-none text-lg font-semibold tracking-tight text-primary-900">
                        {position.role}
                    </dd>
                    <dd className="mt-2 w-full flex-none text-base leading-7 text-gray-600">
                      {position.description}
                    </dd>
                  </dl>
                </li>
              ))}
            </ul>
          </div>
        </div>
        <div className="mt-10 mx-auto flex max-w-2xl flex-col items-end justify-between gap-16 lg:mx-0 lg:max-w-none lg:flex-row">
          <div className="relative isolate bg-white">
            <div className="mx-auto grid max-w-7xl grid-cols-1 lg:grid-cols-2">
              <div className="relative p-6 sm:pt-8 lg:static lg:pl-8">
                <div className="mx-auto max-w-xl lg:mx-0 lg:max-w-lg">
                  <div className="absolute inset-y-0 left-0 -z-10 w-full overflow-hidden bg-gray-100 ring-1 ring-gray-900/10 lg:w-1/2">
                    <svg className="absolute inset-0 h-full w-full stroke-gray-200 [mask-image:radial-gradient(100%_100%_at_top_right,white,transparent)]" aria-hidden="true">
                      <defs>
                        <pattern id="83fd4e5a-9d52-42fc-97b6-718e5d7ee527" width="200" height="200" x="100%" y="-1" patternUnits="userSpaceOnUse">
                          <path d="M130 200V.5M.5 .5H200" fill="none" />
                        </pattern>
                      </defs>
                      <rect width="100%" height="100%" stroke-width="0" fill="white" />
                      <svg x="100%" y="-1" className="overflow-visible fill-gray-50">
                        <path d="M-470.5 0h201v201h-201Z" stroke-width="0" />
                      </svg>
                      <rect width="100%" height="100%" stroke-width="0" fill="url(#83fd4e5a-9d52-42fc-97b6-718e5d7ee527)" />
                    </svg>
                  </div>
                  <h2 className="text-3xl font-bold tracking-tight text-primary-900">{contactGreeting}</h2>
                  <p className="mt-6 text-lg leading-8 text-gray-600">{contactDescription}</p>
                  <dl className="my-10 space-y-4 text-base leading-7 text-gray-600">
                    <div className="flex gap-x-4">
                      <dt className="flex-none">
                        <svg className="h-7 w-6 text-gray-400" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" aria-hidden="true" data-slot="icon">
                          <path stroke-linecap="round" stroke-linejoin="round" d="M2.25 21h19.5m-18-18v18m10.5-18v18m6-13.5V21M6.75 6.75h.75m-.75 3h.75m-.75 3h.75m3-6h.75m-.75 3h.75m-.75 3h.75M6.75 21v-3.375c0-.621.504-1.125 1.125-1.125h2.25c.621 0 1.125.504 1.125 1.125V21M3 3h12m-.75 4.5H21m-3.75 3.75h.008v.008h-.008v-.008Zm0 3h.008v.008h-.008v-.008Zm0 3h.008v.008h-.008v-.008Z" />
                        </svg>
                      </dt>
                      <dd>
                        <a className="hover:text-gray-900" href={addressLink}>{addressPart0}<br/>{addressPart1}</a>
                      </dd>
                    </div>
                    <div className="flex gap-x-4">
                      <dt className="flex-none">
                        <svg className="h-7 w-6 text-gray-400" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" aria-hidden="true" data-slot="icon">
                          <path stroke-linecap="round" stroke-linejoin="round" d="M2.25 6.75c0 8.284 6.716 15 15 15h2.25a2.25 2.25 0 0 0 2.25-2.25v-1.372c0-.516-.351-.966-.852-1.091l-4.423-1.106c-.44-.11-.902.055-1.173.417l-.97 1.293c-.282.376-.769.542-1.21.38a12.035 12.035 0 0 1-7.143-7.143c-.162-.441.004-.928.38-1.21l1.293-.97c.363-.271.527-.734.417-1.173L6.963 3.102a1.125 1.125 0 0 0-1.091-.852H4.5A2.25 2.25 0 0 0 2.25 4.5v2.25Z" />
                        </svg>
                      </dt>
                      <dd>
                        <a className="hover:text-gray-900" href={phone0Link}>{phone0}</a> {phone0Suffix}
                      </dd>
                    </div>
                    <div className="flex gap-x-4">
                      <dt className="flex-none">
                        <svg className="h-7 w-6 text-gray-400" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" aria-hidden="true" data-slot="icon">
                          <path stroke-linecap="round" stroke-linejoin="round" d="M2.25 6.75c0 8.284 6.716 15 15 15h2.25a2.25 2.25 0 0 0 2.25-2.25v-1.372c0-.516-.351-.966-.852-1.091l-4.423-1.106c-.44-.11-.902.055-1.173.417l-.97 1.293c-.282.376-.769.542-1.21.38a12.035 12.035 0 0 1-7.143-7.143c-.162-.441.004-.928.38-1.21l1.293-.97c.363-.271.527-.734.417-1.173L6.963 3.102a1.125 1.125 0 0 0-1.091-.852H4.5A2.25 2.25 0 0 0 2.25 4.5v2.25Z" />
                        </svg>
                      </dt>
                      <dd>
                        <a className="hover:text-gray-900" href={phone1Link}>{phone1}</a> {phone1Suffix}
                      </dd>
                    </div>
                    <div className="flex gap-x-4">
                      <dt className="flex-none">
                        <span className="sr-only">E-mail</span>
                        <svg className="h-7 w-6 text-gray-400" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" aria-hidden="true" data-slot="icon">
                          <path stroke-linecap="round" stroke-linejoin="round" d="M21.75 6.75v10.5a2.25 2.25 0 0 1-2.25 2.25h-15a2.25 2.25 0 0 1-2.25-2.25V6.75m19.5 0A2.25 2.25 0 0 0 19.5 4.5h-15a2.25 2.25 0 0 0-2.25 2.25m19.5 0v.243a2.25 2.25 0 0 1-1.07 1.916l-7.5 4.615a2.25 2.25 0 0 1-2.36 0L3.32 8.91a2.25 2.25 0 0 1-1.07-1.916V6.75" />
                        </svg>
                      </dt>
                      <dd>
                        <a className="hover:text-gray-900" href={mailtoLink}>{email}</a>
                      </dd>
                    </div>
                  </dl>
                  <a
                    href="/contact"
                    className="rounded-md bg-primary-600 px-3.5 py-2.5 text-sm font-semibold text-white shadow-sm hover:bg-primary-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-primary-600">
                    Contact <span aria-hidden="true">&rarr;</span>
                  </a>
                </div>
              </div>
              <div className="relative p-6 sm:pt-8 lg:static lg:pl-8">
              <h2 className="text-3xl font-bold tracking-tight text-primary-900">{whatYouGetGreeting}</h2>
                <ul className="my-8 pl-6 list-disc text-base leading-7 text-gray-600">
                  {whatYouGetList?.map((item) => (
                    <li>{item}</li>
                  ))}
                </ul>
                <h2 className="text-3xl font-bold tracking-tight text-primary-900">{whatYouBringGreeting}</h2>
                <ul className="my-8 pl-6 list-disc text-base leading-7 text-gray-600">
                  {whatYouBringList?.map((item) => (
                    <li>{item}</li>
                  ))}
                </ul>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}