RELEASE_INFO = 'EHR-794athenacds2pass1'
const splits = RELEASE_INFO.trim().split(" ").filter(Boolean);
const TICKET = splits[0]
console.log(TICKET)